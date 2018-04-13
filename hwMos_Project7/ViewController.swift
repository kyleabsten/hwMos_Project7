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

    @IBOutlet var collectionView: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
    

}

