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
    
    let testTable = ["test1", "test2", "test3"]
    
 
    
    var testStudents:[Student] = [Student]()
    
    let studentValue1 = "s1"
    let studentValue2 = "s2"
    let locationValue1 = "l1"
    let locationValue2 = "l2"

    let studentURL = "www.google.com"
    
 
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TableViewController")
    }
    
    override func viewWillAppear(animated: Bool) {    
        super.viewDidLoad()
        print("TableViewController viewWillAppear")
        
 
        getStudentLocations()
        self.tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        print("testStudent.count",self.testStudents.count)

  
        
        return self.testStudents.count
            }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as UITableViewCell!

        
        print("testStudents", testStudents)
        
        let individual = testStudents[indexPath.row]
        //print("individual",individual)
        //cell.textLabel?.text = individual.location
        
        performUIUpdatesOnMain { () -> Void in
            //cell.textLabel?.text = individual.location!
            
            cell.textLabel?.text = individual.firstName! + " " + individual.lastName! + " " + individual.url!
            }
        
        return cell
            }
    
    private func getStudentLocations() {
        print("getStudentLocations")
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
      //  print("request", request)
         
        
        //make request
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            /*
            if error != nil { // Handle error...
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
       */
            func displayError(error: String) {
                print(error)
                //print("URL at time of error: \(url)")
                self.performUIUpdatesOnMain {
                   // self.setUIEnabled(true)
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }

        
            
            //parse data
            
            
            
            let parsedResult: AnyObject!
            do {
                
                let newData = data.subdataWithRange(NSMakeRange(5, (data.length) - 5))
                //print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                //print("parsedResult", parsedResult)
                
                
                
                
                
                let thisParsedResultGroup = parsedResult.objectForKey("results")
                //print("thisParsedResultGroup", thisParsedResultGroup)
                //print("thisParsedResultGroup count",thisParsedResultGroup?.count)
                //print("thisParsedResultGroup type",thisParsedResultGroup?.typeIdentifier)
                let thisParsedResultArray = [thisParsedResultGroup!] as NSArray
                //print("thisParsedResultArray", thisParsedResultArray)
                
                
                let results = parsedResult.objectForKey("results") as! NSArray
                //self.studentFromResults(results as! [[String : AnyObject]])
                 
                self.testStudents = Student.studentFromResults(results as! [[String : AnyObject]])
                
                
                
                self.performUIUpdatesOnMain { () -> Void in
                    self.tableView.reloadData()
                }
                

            }
            catch {

                print("Could not parse the data as JSON: '\(data)'")
                
                return
            }

            
        }
        
        
        
        //use data
        
        
        
        
        //start request
        
        
        
        
        task.resume()
    }
    
    
    func performUIUpdatesOnMain(updates: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            updates()
        }
}
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath")
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        //detailViewController.studentURL = "http://www.google.com"
        
        let thisStudent = testStudents[indexPath.row]
        detailViewController.studentURL = thisStudent.url!
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
}

