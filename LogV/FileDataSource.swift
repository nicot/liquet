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

struct Filter {
    
}

class Lines {
    var lines: [Line]
    let maxPos: Int
    var maxViewLine: Int
    let data: Data
    let filter: Filter
    
    func getLine(for viewRow: Int) -> Line {
        while (viewRow >= lines.count && maxPos < data.count) {
            maxViewLine += 1
            let slice = data[maxPos ..< data.count]
            let maybeLineEnd = slice.firstIndex(of: newline)
            let lineEnd: Int
            if let l = maybeLineEnd {
                lineEnd = l
            } else {
                lineEnd = data.count
            }

            let line = slice[maxPos...lineEnd]

            if matches(line) {
                // TODO figure out a better way to decode this and just show <?> chars
                let t = String(data: line, encoding: .utf8)!
                lines.append(Line(nu: maxViewLine, text: t))
            }
        }

        return lines[viewRow]
    }
    
    func approxCount() -> Int {
        return 100
    }

    func matches(_ line: Data) -> Bool {
        
    }
}

class FileDataSource: NSObject, NSTableViewDataSource {
    var filter: String = "" {
        didSet {
            // do some stuff.
        }
    }

    let data: Data
    let lines: Lines

    init(from fileWrapper: FileWrapper) {
        self.data = fileWrapper.regularFileContents!
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return lines.approxCount()
    }

    func getLineNumber(viewRow: Int) -> Int {
        return lines.getLine(for: viewRow).nu
    }

    func getLine(viewRow: Int) -> String {
        return lines.getLine(for: viewRow).text
    }
}
