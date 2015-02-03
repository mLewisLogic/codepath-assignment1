//
//  ViewController.swift
//  codepath-assignment1
//
//  Created by Michael Lewis on 2/2/15.
//  Copyright (c) 2015 Michael Lewis. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel?.text = "Row: \(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}

