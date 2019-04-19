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

struct Line {
    let nu: Int
    let text: String
}

func runFilter(content: [String], filter: String) -> [Line] {
    var lines: [Line] = []

    for (index, line) in content.enumerated() {
        if (line.contains(filter)) {
            lines.append(Line(nu: index, text: line))
        }
    }

    return lines
}

class Filtered {
    let matchingLines: [Line]

    init(
        lines: [String],
        filter: String
    ) {
        self.matchingLines = runFilter(content: lines, filter: filter)
    }
    
    func getLineNumber(viewRow: Int) -> Int {
        return matchingLines[viewRow].nu
    }
    
    func getLine(viewRow: Int) -> String {
        return matchingLines[viewRow].text
    }
}

class FileDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {
    let contents: [String]
    var filtered: Filtered
    
    init(from fileWrapper: FileWrapper) {
        self.contents = loadFileContents(from: fileWrapper)
        self.filtered = Filtered(lines: contents, filter: "")
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return filtered.matchingLines.count
    }

    let attr = [NSAttributedString.Key.font: NSFont(name: "Menlo", size: CGFloat(12))!]

    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                   row: Int) -> NSView? {
        guard let col = tableColumn else { return nil }
        
        let s: String
        if (col.identifier == NSUserInterfaceItemIdentifier("Numbers")) {
            s = String(row)
        } else if (col.identifier == NSUserInterfaceItemIdentifier("Lines")) {
            s = contents[row]
        } else {
            s = "Uh oh."
        }
        
        let l = NSAttributedString(string: s, attributes: attr)
        return NSTextField(labelWithAttributedString: l)
    }

    func controlTextDidEndEditing(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            self.filtered = Filtered(lines: self.contents, filter: textField.stringValue)
        }
    }
}
