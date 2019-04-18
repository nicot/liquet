//
//  Document.swift
//  LogV
//
//  Created by Dominic Tonozzi on 4/16/19.
//  Copyright © 2019 Nico T. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    var dataSource: FileDataSource?

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let wc = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller"))
        if let windowController = wc as? NSWindowController {
            self.addWindowController(windowController)
            if let vc = windowController.contentViewController as? ViewController {
                vc.data = self.dataSource
            }
        }
    }
    
    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        self.dataSource = FileDataSource(from: fileWrapper)
    }
}
