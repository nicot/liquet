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
    // TODO we shouldn't unwrap here.
    let text = String(data: data, encoding: .utf8)!
    return text.components(separatedBy: "\n")
}

struct Line {
    let nu: Int
    let text: String
}

func runFilter(content: [String], filter: String) -> [Line] {
    var lines: [Line] = []

    if filter == "" {
        return content.enumerated().map { Line(nu: $0, text: $1) }
    }

    for (index, line) in content.enumerated() {
        if (line.contains(filter)) {
            lines.append(Line(nu: index, text: line))
        }
    }

    return lines
}

class Filtered {
    let matchingLines: [Line]
    let rowCount: Int

    init(
        lines: [String],
        filter: String
    ) {
        self.matchingLines = runFilter(content: lines, filter: filter)
        self.rowCount = matchingLines.count
    }

    func getLineNumber(viewRow: Int) -> Int {
        return matchingLines[viewRow].nu
    }

    func getLine(viewRow: Int) -> String {
        return matchingLines[viewRow].text
    }
}

class FileDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    let contents: [String]
    var filtered: Filtered
    
    init(from fileWrapper: FileWrapper) {
        self.contents = loadFileContents(from: fileWrapper)
        self.filtered = Filtered(lines: contents, filter: "")
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return filtered.rowCount
    }

    let attr = [NSAttributedString.Key.font: NSFont(name: "Menlo", size: CGFloat(12))!]

    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                   row: Int) -> NSView? {
        guard let col = tableColumn else { return nil }

        let v = tableView.makeView(withIdentifier: col.identifier, owner: tableView)
    
        if let t = v?.subviews[0] as? NSTextField {
            if (col.identifier == NSUserInterfaceItemIdentifier("Numbers")) {
                t.stringValue = String(filtered.getLineNumber(viewRow: row) + 1)
            } else if (col.identifier == NSUserInterfaceItemIdentifier("Lines")) {
                t.stringValue = filtered.getLine(viewRow: row)
            }
        }
        
        return v
    }
}
