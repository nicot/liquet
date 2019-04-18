//
//  FileDataSource.swift
//  LogV
//
//  Created by Dominic Tonozzi on 4/16/19.
//  Copyright © 2019 Nico T. All rights reserved.
//

import Cocoa

class FileDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let fileWrapper: FileWrapper
    
    init(from fileWrapper: FileWrapper) {
        self.fileWrapper = fileWrapper
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 300
    }
    
    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                   row: Int) -> NSView? {
        guard let col = tableColumn else { return nil }
        
        if (col.identifier == NSUserInterfaceItemIdentifier("Numbers")) {
            let font = NSFont(name: "Menlo", size: CGFloat(12))!
            let l = NSAttributedString(string: String(row), attributes: [NSAttributedString.Key.font: font])
            let v = NSTextField(labelWithAttributedString: l)
            return v
        } else if (col.identifier == NSUserInterfaceItemIdentifier("Lines")) {
            let font = NSFont(name: "Menlo", size: CGFloat(12))!
            let l = NSAttributedString(string: "foo bar", attributes: [NSAttributedString.Key.font: font])
            let v = NSTextField(labelWithAttributedString: l)
            return v
        } else {
            return nil
        }
    }
}
