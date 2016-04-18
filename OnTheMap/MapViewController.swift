//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/12/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var appDelegate: AppDelegate!
    var student: Student?
    var testStudents:[Student] = [Student]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController viewDidLoad")
        
           }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        
        print("MapViewController viewWillAppear")
        
        getStudentLocations()
        
        print("testStudents.count" , testStudents.count)
        
        let locations = testLocationData()
        
        var annotations = [MKPointAnnotation]()
        
/* ---
        for dictionary in locations {
            
            //let lat = CLLocationDegrees(dictionary["latititude"] as! Double)
            let lat1 = CLLocationDegrees(38.1461248)
            
            //let long = CLLocationDegrees(dictionary["longititude"] as! Double)
            let long1 = CLLocationDegrees(-92.75676799999999)
            
            let coordinate1 = CLLocationCoordinate2D(latitude: lat1, longitude: long1)
            
            let lat2 = CLLocationDegrees(36.1461248)
            
            //let long = CLLocationDegrees(dictionary["longititude"] as! Double)
            let long2 = CLLocationDegrees(-90.75676799999999)
            
            let coordinate2 = CLLocationCoordinate2D(latitude: lat2, longitude: long2)
            
            //let first = dictionary["firstName"] as! String
            //let last = dictionary["lastName"] as! String
            //let mediaURL = dictionary["medaURL"] as! String
            
            let annotation1 = MKPointAnnotation()
            annotation1.coordinate = coordinate1
            annotation1.title = "student annotation 1"
            
            let annotation2 = MKPointAnnotation()
            annotation2.coordinate = coordinate2
            annotation2.title = "student annotation 2"


            
            /*
            reloadInputViews()
            
            if (testStudents.count > 0) {
                annotation1.title = testStudents[0].name
            }
            else {
                annotation1.title = "student annotation 1"
            }
            
            if (testStudents.count > 0) {
                annotation2.title = testStudents[0].name
            }
            else {
                annotation2.title = "student annotation 2"
            }
*/
            
            //annotation.title = "Coordinate"
            //annotation.title = testStudents[0].name
            
            annotations.append(annotation1)
            
            annotations.append(annotation2)
            
        }
        
        self.mapView.addAnnotations(annotations)
--- */
        
        
        
        for student in testStudents {
            
            //let lat = CLLocationDegrees(dictionary["latititude"] as! Double)
            //let lat1 = CLLocationDegrees(38.1461248)
            let lat1 = CLLocationDegrees(student.name)
            print("lat1", lat1)
            
            //let long = CLLocationDegrees(dictionary["longititude"] as! Double)
            //let long1 = CLLocationDegrees(-92.75676799999999)
            let long1 = CLLocationDegrees(student.location)
            
            let coordinate1 = CLLocationCoordinate2D(latitude: lat1, longitude: long1)
            
            //let lat2 = CLLocationDegrees(36.1461248)
            
            //let long = CLLocationDegrees(dictionary["longititude"] as! Double)
            //let long2 = CLLocationDegrees(-90.75676799999999)
            
            //let coordinate2 = CLLocationCoordinate2D(latitude: lat2, longitude: long2)
            
            //let first = dictionary["firstName"] as! String
            //let last = dictionary["lastName"] as! String
            //let mediaURL = dictionary["medaURL"] as! String
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate1
            annotation.title = student.url
            
            
            /*
            reloadInputViews()
            
            if (testStudents.count > 0) {
            annotation1.title = testStudents[0].name
            }
            else {
            annotation1.title = "student annotation 1"
            }
            
            if (testStudents.count > 0) {
            annotation2.title = testStudents[0].name
            }
            else {
            annotation2.title = "student annotation 2"
            }
            */
            
            //annotation.title = "Coordinate"
            //annotation.title = testStudents[0].name
            
            annotations.append(annotation)
            
        }
        
        self.mapView.addAnnotations(annotations)
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func testLocationData() -> [[String : AnyObject]] {
        return [
            [
                "latitude" : 28.1461248,
                "longitude" : -82.75676799999999
               // "mapString" : "Tarpon Springs, FL"
            ]
        ]
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
                
                
                let results = parsedResult.objectForKey("results") as! NSArray
                //self.studentFromResults(results as! [[String : AnyObject]])
                
                self.testStudents = Student.studentFromResults(results as! [[String : AnyObject]])
                
                //let movies = TMDBMovie.moviesFromResults(results)
                
                
                /*
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
                */
                
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
                
                
                //self.performUIUpdatesOnMain { () -> Void in
                //    self.tableView.reloadData()
                //}
                
                
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
    
}