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
        return 3
    }

    func getLineNumber(viewRow: Int) -> Int {
        return viewRow
    }

    func getLine(viewRow: Int) -> String {
        return "foo"
    }
}
