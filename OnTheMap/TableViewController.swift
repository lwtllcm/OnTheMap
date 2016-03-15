//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/12/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var student: Student?
    
    let testTable = ["test1", "test2", "test3"]
    let testStudent = Student(dictionary: ["name": "aaa", "location":"bbb"])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TableViewController")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {    
        super.viewDidLoad()
        print("TableViewController viewWillAppear")
        print("testStudent ", testStudent)

  
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testTable.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as UITableViewCell!
        //let individual = testTable[indexPath.row]
        //cell.textLabel?.text = individual
        cell.textLabel?.text = testStudent.name
        return cell
            }
}