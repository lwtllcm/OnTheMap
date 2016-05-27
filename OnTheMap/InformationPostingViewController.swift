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
            
            print("thisCoordinate",thisCoordinate)
            
            
            
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
    }
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        print(studentLinkText.text)
        print("submitButtonPressed")
        
        
        let defaults = NSUserDefaults.standardUserDefaults()

        let studentMediaURL = studentLinkText.text as String!
        let studentFirstName = defaults.stringForKey("Udacity.FirstName")!
        let studentLastName = defaults.stringForKey("Udacity.LastName")!
        let studentLatitude = self.latitude
        let studentLongitude = self.longitude
        let studentMapString = studentLocationText.text as String!
    
        
        
       let jsonBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(studentFirstName)\", \"lastName\": \"\(studentLastName)\",\"mapString\": \"\(studentMapString)\", \"mediaURL\": \"\(studentMediaURL)\",\"latitude\": \(studentLatitude), \"longitude\": \(studentLongitude)}"
        
        
        print("jsonBody", jsonBody)
        
        DBClient.sharedInstance().taskForPOSTMethod(jsonBody) { (results, error) in
            print("taskForPostMethod")
            
            if (error != nil) {
                
                let uiAlertController = UIAlertController(title: "post error", message: nil, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
            }
            
            
        }
        
        
        
        
        
        print("postStudentLocation completed")
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        print("cancelButtonPressed")
        navigationController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    private func postStudentLocation() {
        print("postStudentLocation")
        
        
        let thisStudent =
        Student(firstName:studentLinkText.text!  , lastName:" " , location:" " ,latitude: self.latitude, longitude: self.longitude, url: studentLinkText.text! as String, updatedAt: NSCalendar.currentCalendar())
        print("thisStudent", thisStudent)
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Holly\", \"lastName\": \"Doe\",\"mapString\": \"Sacremento, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        
        
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
