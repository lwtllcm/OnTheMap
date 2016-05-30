//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/12/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    var appDelegate: AppDelegate!
    
    var student: Student?
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    
    //var allStudents:[Student] = [Student]()
    
    
  
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TableViewController")
    }
    
    override func viewWillAppear(animated: Bool) {    
        super.viewWillAppear(animated)
        print("TableViewController viewWillAppear")
        
 
           DBClient.sharedInstance().taskForGETMethod { (results, error) in
            print("taskForGetMethod")
            print("results from taskForGETMethod", results)
            print("error from taskForGETMethod", error)
            
            
            if (error != nil) {
        
                NSOperationQueue.mainQueue().addOperationWithBlock {
                let uiAlertController = UIAlertController(title: "download error", message: nil, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
            }
            }
            
           // let results = results.objectForKey("results") as! NSArray
            
          // self.allStudents = Student.studentFromResults(results as! [[String : AnyObject]])
            
            self.performUIUpdatesOnMain { () -> Void in
                self.performUIUpdatesOnMain({ () -> Void in
                    print("performUIUpdatesOnMain")
                    self.tableView.reloadData()
                })
                self.tableView.reloadData()
                
            }
            
        }

    
        self.tableView.reloadData()
        
   }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
       // print("testStudent.count",self.allStudents.count)
        
        //return self.allStudents.count
        
        if Students.allStudents.count == 0 {
            return 1
        }
        
        else {
        
            return Students.allStudents.count
  
            }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as UITableViewCell!

        
        //print("allStudents", allStudents)
        
        //let individual = allStudents[indexPath.row]
        
        let individual = Students.allStudents[indexPath.row]
        
        performUIUpdatesOnMain { () -> Void in
            
            cell.textLabel?.text = individual.firstName! + " " + individual.lastName! + " " + individual.url!
           
        }
        
        return cell
            }

  
    
    func performUIUpdatesOnMain(updates: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            updates()
        }
}
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath")
        
       // let selectedStudentURL = allStudents[indexPath.row].url
        let selectedStudentURL = Students.allStudents[indexPath.row].url
        
        
        let url = NSURL(string: (selectedStudentURL!))!
        
        UIApplication.sharedApplication().openURL(url)
        
        
    }
    
    
}

