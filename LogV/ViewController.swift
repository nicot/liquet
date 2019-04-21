//
//  ViewController.swift
//  LogR
//
//  Created by Dominic Tonozzi on 4/14/19.
//  Copyright © 2019 Nico T. All rights reserved.
//

import Cocoa

class FilterTextFieldDelegate: NSObject, NSTextFieldDelegate {
    let table: NSTableView
    let dataSource: FileDataSource

    init(_ v: NSTableView, _ d: FileDataSource) {
        self.table = v
        self.dataSource = d
    }

    // I'm not sure if this is better to do on change or on enter. (controlTextDidChange vs controlTextDidEndEditing)
    func controlTextDidEndEditing(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            self.dataSource.filter = textField.stringValue

            table.reloadData()
        }
    }
}

class LogTableViewDelegate: NSObject, NSTableViewDelegate {
    let dataSource: FileDataSource
    
    init(dataSource: FileDataSource) {
        self.dataSource = dataSource
    }

    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                   row: Int) -> NSView? {
        guard let col = tableColumn else { return nil }
        
        let v = tableView.makeView(withIdentifier: col.identifier, owner: tableView)
        
        if let t = v?.subviews[0] as? NSTextField {
            if (col.identifier == NSUserInterfaceItemIdentifier("Numbers")) {
                t.stringValue = String(self.dataSource.getLineNumber(viewRow: row) + 1)
            } else if (col.identifier == NSUserInterfaceItemIdentifier("Lines")) {
                t.stringValue = self.dataSource.getLine(viewRow: row)
            }
        }
        
        return v
    }
}

class ViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var input: NSTextField!

    var filterDelegate: FilterTextFieldDelegate?
    var viewDelegate: LogTableViewDelegate?
    
    var data: FileDataSource? {
        didSet {
            loadView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let data = self.data else { return }

        self.tableView.dataSource = data
        self.viewDelegate = LogTableViewDelegate(dataSource: data)
        self.tableView.delegate = self.viewDelegate
        self.filterDelegate = FilterTextFieldDelegate(tableView, data)
        input.delegate = self.filterDelegate
    }
}

