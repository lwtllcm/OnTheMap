//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/28/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate {
   
    @IBOutlet weak var studentLocationPromptLabel: UILabel!
    
    
    @IBOutlet weak var studentLocationText: UITextField!
    
    @IBOutlet weak var studentLinkText: UITextField!
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
   
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.hidden = true
        studentLocationPromptLabel.hidden = false
        studentLinkText.hidden = true
        submitButton.hidden = true
        activityIndicator.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("InformationPostingViewController")
        //activityIndicator.alpha = 1.0
        
        //activityIndicator.startAnimating()
        
    }
    @IBAction func studentLocationTextAction(sender: AnyObject) {
        print("studentLocationText entered")
       
    }
    
    @IBAction func findOnTheMapButtonPressed(sender: AnyObject) {
        print("Find on the Map pressed")
        print(studentLocationText)
        
        activityIndicator.hidden = false
        activityIndicator.alpha = 1.0
        
        activityIndicator.startAnimating()
        
        let geocoder = CLGeocoder()
       // var placemarks = [CLPlacemark]()
        

        geocoder.geocodeAddressString(studentLocationText.text!, completionHandler: {placemarks, error in

            
            if (error != nil) {
                print("geocoding error")
                let uiAlertController = UIAlertController(title: "geocoding error", message: nil, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
                self.activityIndicator.alpha = 0.0
                self.activityIndicator.stopAnimating()

                
            }
            else {
            
            let thisPlacemark = placemarks![0]
            print(thisPlacemark)
            print(thisPlacemark.location)
            let thisCoordinate:CLLocationCoordinate2D = (thisPlacemark.location?.coordinate)!
            
            self.latitude = thisCoordinate.latitude
            self.longitude = thisCoordinate.longitude
            
            print(thisCoordinate)
            
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = thisCoordinate
            
            self.mapView.addAnnotation(annotation)
            
            let regionRadius: CLLocationDistance = 1000
            
            
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(thisCoordinate, regionRadius * 2.0, regionRadius * 2.0)
            self.mapView.setRegion(coordinateRegion, animated: true)
            self.mapView.centerCoordinate = thisCoordinate
            
            
            
            self.activityIndicator.alpha = 0.0
            self.activityIndicator.stopAnimating()
            
            
                
           self.mapView.hidden = false
           self.studentLocationPromptLabel.hidden = true
                self.studentLocationText.hidden = true
                self.findOnTheMapButton.hidden = true
                self.studentLinkText.hidden = false
                self.submitButton.hidden = false
                
            self.reloadInputViews()
                
                
            }
            
        })
/*
        mapView.hidden = false
        studentLocationPromptLabel.hidden = true
        studentLocationText.hidden = true
        findOnTheMapButton.hidden = true
        studentLinkText.hidden = false
        submitButton.hidden = false
*/
    }
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        print(studentLinkText.text)
        print("submitButtonPressed")
        
        //self.postStudentLocation()
        
        let mediaURL = studentLinkText.text as String!
    
        
        //let jsonBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Holly\", \"lastName\": \"Doe\",\"mapString\": \"Sacremento, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}"
        
       let jsonBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Holly\", \"lastName\": \"Doe\",\"mapString\": \"Sacremento, CA\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": 37.386052, \"longitude\": -122.083851}"
        
        DBClient.sharedInstance().taskForPOSTMethod(jsonBody) { (results, error) in
            print("taskForPostMethod")
           // print("results from taskForPOSTMethod", results)
           // print("error from taskForPOSTMethod", error)
            
            
            if (error != nil) {
                
                let uiAlertController = UIAlertController(title: "post error", message: nil, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
            }
            
            /*
            let results = results.objectForKey("results") as! NSArray
            
            self.allStudents = Student.studentFromResults(results as! [[String : AnyObject]])
           
            self.performUIUpdatesOnMain { () -> Void in
                self.performUIUpdatesOnMain({ () -> Void in
                    print("performUIUpdatesOnMain")
                    self.tableView.reloadData()
                })
                self.tableView.reloadData()
                
            }
            */
            
        }
        
        
        
        
        
        print("postStudentLocation completed")
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        print("cancelButtonPressed")
        navigationController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    private func postStudentLocation() {
        print("postStudentLocation")
        
        
        //var newStudent:Student
        //newStudent.firstName = studentLinkText.text
        //newStudent.lastName = " "
        //newStudent.location = " "
        //newStudent.latitude = self.latitude
        //newStudent.longitude = self.longitude
        
    
        //print("newStudent", newStudent.firstName, newStudent.lastName, newStudent.latitude, newStudent.longitude)
        
        
        
        let thisStudent =
        Student(firstName:studentLinkText.text!  , lastName:" " , location:" " ,latitude: self.latitude, longitude: self.longitude, url: studentLinkText.text! as String, updatedAt: NSCalendar.currentCalendar())
        print("thisStudent", thisStudent)
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Holly\", \"lastName\": \"Doe\",\"mapString\": \"Sacremento, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        
        //request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Jane\", \"lastName\": \"Doe\",\"mapString\": \"San Francisco, CA\", \"mediaURL\": ".dataUsingEncoding(NSUTF8StringEncoding)
        //request.HTTPBody.append(thisStudent.url?.dataUsingEncoding(NSUTF8StringEncoding))
        //request.HTTPBody.append(\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding))
        
        
        /*
        var requestURLString = "{\"uniqueKey\": \"1234\", \"firstName\": \"Jane\", \"lastName\": \"Doe\",\"mapString\": \"San Francisco, CA\", \"mediaURL\": "
        requestURLString = requestURLString + thisStudent.url!
        requestURLString = requestURLString + ",\"latitude\": 37.386052, \"longitude\": -122.083851}"
        request.HTTPBody = requestURLString.dataUsingEncoding(NSUTF8StringEncoding)
        print("request.HTTPBody", request.HTTPBody)
        */
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print("rdata from postStudentLocation", data)

            print("response from postStudentLocation", response)
            if error != nil {
                
                
                let uiAlertController = UIAlertController(title: "post error", message: nil, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
                self.activityIndicator.alpha = 0.0
                self.activityIndicator.stopAnimating()

                
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
      
    }

}
