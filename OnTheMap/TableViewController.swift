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
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
  
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TableViewController")
    }
    
    override func viewWillAppear(animated: Bool) {    
        super.viewWillAppear(animated)
        print("TableViewController viewWillAppear")
        
        
        //Students.allStudents.removeAll()

 
           DBClient.sharedInstance().taskForGETMethod { (results, error) in
            print("taskForGetMethod")
            print("results from taskForGETMethod", results)
            print("error from taskForGETMethod", error)
            
            
            if (error != nil) {
                
                print(error?.localizedDescription)
                let errorMsg  = error?.localizedDescription
        
                NSOperationQueue.mainQueue().addOperationWithBlock {
                let uiAlertController = UIAlertController(title: "download error", message: errorMsg, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
            }
            }
            
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
        
        if Students.allStudents.count == 0 {
            return 1
        }
        
        else {
        
            return Students.allStudents.count
  
            }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as UITableViewCell!

        
        let individual = Students.allStudents[indexPath.row]
        
        performUIUpdatesOnMain { () -> Void in
            
            cell.textLabel?.text = individual.firstName! + " " + individual.lastName! 
           
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
        
        let selectedStudentURL = Students.allStudents[indexPath.row].url
        
        
        let url = NSURL(string: (selectedStudentURL!))!
        
        UIApplication.sharedApplication().openURL(url)
        
        
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        
        
        //Students.allStudents.removeAll()

        DBClient.sharedInstance().taskForGETMethod { (results, error) in
            print("taskForGetMethod")
            print("results from taskForGETMethod", results)
            print("error from taskForGETMethod", error)
            
            
            if (error != nil) {
                
                print(error?.localizedDescription)
                let errorMsg  = error?.localizedDescription
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    let uiAlertController = UIAlertController(title: "download error", message: errorMsg, preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    uiAlertController.addAction(defaultAction)
                    self.presentViewController(uiAlertController, animated: true, completion: nil)
                }
            }
            Students.allStudents.removeAll()
            print("allStudents count", Students.allStudents.count)
            let results = results.objectForKey("results") as! NSArray
            
            for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
                    
                    Students.allStudents.append(student)
                }
           
            
            self.performUIUpdatesOnMain { () -> Void in
        self.tableView.reloadData()
            }
        }
    }
}

