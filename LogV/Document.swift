//
//  Document.swift
//  LogV
//
//  Created by Dominic Tonozzi on 4/16/19.
//  Copyright © 2019 Nico T. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    var fileWrapper: FileWrapper?

    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let wc = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller"))
        if let windowController = wc as? NSWindowController {
            self.addWindowController(windowController)
            if let vc = windowController.contentViewController as? ViewController {
                vc.data = FileDataSource(from: fileWrapper!)
            }
        }
    }

    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        self.fileWrapper = fileWrapper
    }
}
