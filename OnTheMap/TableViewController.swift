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
    let testStudent = Student(dictionary: ["name": "aaa", "location":"bbb"])
    var testStudents = [NSDictionary]()

    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TableViewController")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {    
        super.viewDidLoad()
        print("TableViewController viewWillAppear")
        print("testStudent ", testStudent)
        
        getStudentLocations()

  
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        print("testStudent.count",self.testStudents.count)

        return testTable.count
        
        //return self.testStudents.count
            }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as UITableViewCell!
        //let individual = testTable[indexPath.row]
        //cell.textLabel?.text = individual
        cell.textLabel?.text = testStudent.name
        return cell
            }
    
    private func getStudentLocations() {
        print("getStudentLocations")
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        print("request", request)
        
        
        //make request
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
       
        
            
            //parse data
            let parsedResult: AnyObject!
            do {
                let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5))
                print(NSString(data: newData!, encoding: NSUTF8StringEncoding))
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                print("parsedResult", parsedResult)
                
                let thisParsedResultGroup = parsedResult.objectForKey("results")
                print("thisParsedResultGroup", thisParsedResultGroup)
                
                
                let thisParsedResult = thisParsedResultGroup![0]
                print("thisParsedResult firstName", thisParsedResult.objectForKey("firstName"))
                print("thisParsedResult mapString", thisParsedResult.objectForKey("mapString"))
                let newTestStudent = ["name": thisParsedResult.objectForKey("firstName"), "location":thisParsedResult.objectForKey("mapString")]
                self.testStudents.append(["name": thisParsedResult.objectForKey("firstName")!, "location":thisParsedResult.objectForKey("mapString")!])
                print("self.testStudents",self.testStudents)

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
    
    /*
    private func loginWithToken(requestToken:String) {
        
    }
    
    func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        print("parseURLFromParameters")
        let components = NSURLComponents()
        
        components.scheme = "https"
        components.host = "udacity.com"
        components.path = "/api/session" + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        // print(components.URL!)
        return components.URL!
    }
*/
    
    
}