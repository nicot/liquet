//
//  ViewController.swift
//  LogR
//
//  Created by Dominic Tonozzi on 4/14/19.
//  Copyright © 2019 Nico T. All rights reserved.
//

import Cocoa

class Del: NSObject, NSTextFieldDelegate {
    let table: NSTableView
    let dataSource: FileDataSource

    init(_ v: NSTableView, _ d: FileDataSource) {
        self.table = v
        self.dataSource = d
    }

    // I'm not sure if this is better to do on change or on enter.
    func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            self.dataSource.filtered = Filtered(lines: self.dataSource.contents, filter: textField.stringValue)
        }

        table.reloadData()
    }
}

class ViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var input: NSTextField!
    
    var delegate: Del?
    
    var data: FileDataSource? {
        didSet {
            loadView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = data
        self.tableView.delegate = data
        if let d = data {
            self.delegate = Del(tableView, d)
            input.delegate = self.delegate
        }
    }
}

