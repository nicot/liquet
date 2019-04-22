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
    let text: String
}

func matches(_ text: String, filter: Filter) -> Bool {
    if filter.text == "" {
        return true
    }

    return text.contains(filter.text)
}

class Lines {
    var lines: [Line] = []
    var maxViewLine: Int = 0
    var maxPos: Int = 0
    let data: Data
    let filter: Filter

    init(_ data: Data, filter: String) {
        self.data = data
        self.filter = Filter(text: filter)
    }

    func getLine(for viewRow: Int) -> Line {
        while (viewRow >= lines.count && maxPos < data.count) {
            let slice = data[maxPos ..< data.count]
            let maybeLineEnd = slice.firstIndex(of: newline)
            let lineEnd: Int
            if let l = maybeLineEnd {
                lineEnd = l
            } else {
                lineEnd = data.count
            }

            let line = slice[maxPos..<lineEnd]
            // TODO figure out a better way to decode this and show <?> chars
            let t = String(data: line, encoding: .utf8)!
            if matches(t, filter: filter) {
                lines.append(Line(nu: maxViewLine, text: t))
            }

            maxViewLine += 1
            maxPos = lineEnd + 1
        }
        
        if viewRow >= lines.count {
            return Line(nu: 0, text: "foo")
        }

        return lines[viewRow]
    }

    func approxCount() -> Int {
        return 100
    }
}

class FileDataSource: NSObject, NSTableViewDataSource {
    var filter: String {
        didSet {
            self.lines = Lines(data, filter: self.filter)
        }
    }

    let data: Data
    var lines: Lines

    init(from fileWrapper: FileWrapper) {
        self.data = fileWrapper.regularFileContents!
        self.filter = ""
        self.lines = Lines(data, filter: self.filter)
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
