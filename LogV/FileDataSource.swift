//
//  FileDataSource.swift
//  LogV
//
//  Created by Dominic Tonozzi on 4/16/19.
//  Copyright © 2019 Nico T. All rights reserved.
//

import Cocoa

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

let newline = UInt8(0x0a)

func lineCount(data: Data) -> Int {
    var i = 0
    var startIndex = 0
    while true {
        let slice = data[startIndex ..< data.count]
        if let n = slice.firstIndex(of: newline) {
            i += 1
            startIndex = n + 1
        } else {
            return i
        }
    }
}

class FileDataSource: NSObject, NSTableViewDataSource {
    var filter: String = "" {
        didSet {
            // do some stuff.
        }
    }

    let data: Data

    init(from fileWrapper: FileWrapper) {
        self.data = fileWrapper.regularFileContents!
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return lineCount(data: data)
    }

    func getLineNumber(viewRow: Int) -> Int {
        return viewRow
    }

    func getLine(viewRow: Int) -> String {
        return "foo"
    }
}
