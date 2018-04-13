//
//  Photo.swift
//  hwMos_Project7
//
//  Created by Kyle Absten on 4/10/18.
//  Copyright © 2018 Kyle Absten. All rights reserved.
//

import Cocoa

class Photo: NSCollectionViewItem {
    
    let selecetedBorderThickness: CGFloat = 3
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                view.layer?.borderWidth = selecetedBorderThickness
            } else {
                view.layer?.borderWidth = 0
            }
            
        }
    }
    
    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet{
            if highlightState == .forSelection {
                view.layer?.borderWidth = selecetedBorderThickness
            } else {
                if !isSelected {
                    view.layer?.borderWidth = 0
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.borderColor = NSColor.blue.cgColor
    }
    
    
    
}
