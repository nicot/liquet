//
//  FileDataSource.swift
//  LogV
//
//  Created by Dominic Tonozzi on 4/16/19.
//  Copyright © 2019 Nico T. All rights reserved.
//

import Cocoa

func loadFileContents(from file: FileWrapper) -> [String] {
    let data: Data = file.regularFileContents!
    let text = String(data: data, encoding: .utf8)!
    return text.components(separatedBy: "\n")
}

class FileDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {
    let file: FileWrapper
    let contents: [String]
    
    init(from fileWrapper: FileWrapper) {
        self.file = fileWrapper
        self.contents = loadFileContents(from: fileWrapper)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return contents.count
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
            let c = contents[row]
            let font = NSFont(name: "Menlo", size: CGFloat(12))!
            let l = NSAttributedString(string: c, attributes: [NSAttributedString.Key.font: font])
            let v = NSTextField(labelWithAttributedString: l)
            return v
        } else {
            return nil
        }
    }
    
    func controlTextDidChange(_ obj: Notification) {
        print("foo")
    }
}
