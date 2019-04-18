//
//  Document.swift
//  LogV
//
//  Created by Dominic Tonozzi on 4/16/19.
//  Copyright © 2019 Nico T. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }
    
    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
//         TODO support compressed files.
//         if (typeName == "public.tar-archive" || typeName == "

//        let vc = windowControllers[0].contentViewController as! ViewController
//        Swift.print(vc.data)
        let data = FileDataSource(from: fileWrapper)
    }
}
