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
    
   // let testStudent = Student(dictionary: ["name": "Student 1", "location":"Location 1"])
   // let testStudent2 = Student(dictionary: ["name" : "Student 2", "location":"Location 2"])
   // let testStudent3 = Student(dictionary: ["name" : "Student 3", "location":"Location 3"])

    var testStudents = [Student]()
    
    let studentValue1 = "s1"
    let studentValue2 = "s2"
    let locationValue1 = "l1"
    let locationValue2 = "l2"
    
    var testStudent1 = Student(name:"s1", location:"l1")
    var testStudent2 = Student(name:"s2", location:"l2")
    var testStudent3 = Student(name:"s3", location:"l3")

    
    
    
   // var testStudent1 = Student(name:studentValue1, location:locationValue1)
    //testStudent1.
    //testStudent1 = Student("name":"name1", "location":"location1")
   
    
    //location = (dictionary["location"] as? String)!
    
    
    //testStudents.append(["name": "Student 1", "location":"Location 1"])
    //testStudents.append(["name" : "Student 2", "location":"Location 2"])
    //testStudents.append(["name" : "Student 3", "location":"Location 3"])

    //print("testStudents", testStudents)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TableViewController")
    }
    
    override func viewWillAppear(animated: Bool) {    
        super.viewDidLoad()
        print("TableViewController viewWillAppear")
        
        testStudents.append(testStudent1)
        
       // testStudents.append(testStudent2
       // testStudents.append(testStudent3)
        

        getStudentLocations()
        self.tableView.reloadData()
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        print("testStudent.count",self.testStudents.count)

        //return testTable.count
        
        return self.testStudents.count
            }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as UITableViewCell!
        //let individual = testTable[indexPath.row]
        
        //cell.textLabel?.text = individual
        //cell.textLabel?.text = testStudent.name
        print("testStudents", testStudents)
        let individual = testStudents[indexPath.row]
        print("individual",individual)
        //cell.textLabel?.text = individual.location
        
        performUIUpdatesOnMain { () -> Void in
            cell.textLabel?.text = individual.location
        }
        
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
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                print("parsedResult", parsedResult)
                
                
                
                
                
                let thisParsedResultGroup = parsedResult.objectForKey("results")
                print("thisParsedResultGroup", thisParsedResultGroup)
                print("thisParsedResultGroup count",thisParsedResultGroup?.count)
                print("thisParsedResultGroup type",thisParsedResultGroup?.typeIdentifier)
                let thisParsedResultArray = [thisParsedResultGroup!] as NSArray
                print("thisParsedResultArray", thisParsedResultArray)
                
                
                for result in parsedResult.objectForKey("results") as! NSArray {
                    print("result", result)
                    print("result firstName", result.objectForKey("firstName"))
                    print("result location", result.objectForKey("mapString"))
                    let resultName = result.objectForKey("firstName")
                    print("resultName", resultName)
                    let resultLocation = result.objectForKey("updatedAt")
                    print("resultLocation", resultLocation)

                    let newTestStudent = Student(name:resultName as! String, location:resultLocation as! String)
                    print("newTestStudent", newTestStudent)
                    self.testStudents.append(newTestStudent)
                    print(self.testStudents)
                    
                }
                
                /*
                let thisParsedResult = thisParsedResultGroup![0]
                print("thisParsedResult firstName", thisParsedResult.objectForKey("firstName"))
                let thisParsedResultFirstName = thisParsedResult.objectForKey("firstName")
                
                print("thisParsedResult mapString", thisParsedResult.objectForKey("mapString"))
                let thisParsedResultmapString = thisParsedResult.objectForKey("mapString")


                
                let newTestStudent = Student(name:thisParsedResultFirstName as! String, location:thisParsedResultmapString as! String)
                self.testStudents.append(newTestStudent)
                print("self.testStudents",self.testStudents)
*/
              
                /*
                if let parsedResultArray = parsedResult as? NSArray {
                for newTest in parsedResultArray {
                    print("newTest", newTest)
                }
                }
                */
                
                
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
   /*
    static func studentFromResults(results: [[String:AnyObject]] )-> [Student] {
        var students = [Student] ()
        for result in results {
            students.append(Student(dictionary: result))
        }
        
        return students
    }
   */

}

