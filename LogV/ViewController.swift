//
//  ViewController.swift
//  LogR
//
//  Created by Dominic Tonozzi on 4/14/19.
//  Copyright © 2019 Nico T. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var input: NSTextField!

    var data: FileDataSource? {
        didSet {
            loadView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = data
        tableView.delegate = data

        // Do any additional setup after loading the view.
    }
}

