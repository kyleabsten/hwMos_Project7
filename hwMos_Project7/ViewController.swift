//
//  ViewController.swift
//  hwMos_Project7
//
//  Created by Kyle Absten on 4/10/18.
//  Copyright © 2018 Kyle Absten. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {
    
    lazy var photosDirectory: URL = {
        let fm = FileManager.default
        let paths = fm.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let saveDirectory = documentsDirectory.appendingPathComponent("SlideMark")
        
        if !fm.fileExists(atPath: saveDirectory.path) {
            try? fm.createDirectory(at: saveDirectory, withIntermediateDirectories: true)
        }
        return saveDirectory
    }()
    
    var photos = [URL]()
    var itemsBeingDragged: Set<IndexPath>?

    @IBOutlet var collectionView: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.registerForDraggedTypes([NSPasteboard.PasteboardType(kUTTypeURL as String)])
        
        do {
            let fm = FileManager.default
            let files = try fm.contentsOfDirectory(at: photosDirectory, includingPropertiesForKeys: nil)
            for file in files {
                if file.pathExtension.lowercased() == "jpg" || file.pathExtension.lowercased() == "png" || file.pathExtension.lowercased() == "jpeg" {
                    photos.append(file)
                }
            }
        } catch {
            print("Set up error")
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("Photo"), for: indexPath)
        
        guard let pictureItem = item as? Photo else { return item }
        
        pictureItem.view.wantsLayer = true
        let image = NSImage(contentsOf: photos[indexPath.item])
        pictureItem.imageView?.image = image
        return pictureItem
    }
    
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
        return .move
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        itemsBeingDragged = indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        itemsBeingDragged = nil
    }
    
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
        if let moveItems = itemsBeingDragged?.sorted() {
            performInternalDrag(with: moveItems, to: indexPath)
        } else {
            guard let moveItems = draggingInfo.draggingPasteboard().pasteboardItems else { return true }
            performExternalDrag(with: moveItems, at: indexPath)
        }
        return true
    }
    
    func performInternalDrag(with items: [IndexPath], to indexPath: IndexPath) {
        
    }
    
    func performExternalDrag(with items: [NSPasteboardItem], at indexPath: IndexPath) {
        for item in items {
            guard let urlString = item.string(forType: NSPasteboard.PasteboardType(kUTTypeFileURL as String)) else { continue }
            guard let fileUrl = URL(string: urlString) else { continue }
            let destinationPath = photosDirectory.appendingPathComponent(fileUrl.lastPathComponent)
            let fm = FileManager.default
            do {
                try fm.copyItem(at: fileUrl, to: destinationPath)

            } catch {
                let ac = NSAlert()
                ac.messageText = "Could not copy \(fileUrl)"
                ac.runModal()
            }
            photos.insert(destinationPath, at: indexPath.item)
            collectionView.insertItems(at: [indexPath])
          
        }
        
    }

}

