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
   
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.hidden = true
        studentLocationPromptLabel.hidden = false
        studentLinkText.hidden = true
        submitButton.hidden = true
        
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
        
        let geocoder = CLGeocoder()
       // var placemarks = [CLPlacemark]()
        

        geocoder.geocodeAddressString(studentLocationText.text!, completionHandler: {placemarks, error in

            let thisPlacemark = placemarks![0]
            print(thisPlacemark)
            print(thisPlacemark.location)
            let thisCoordinate:CLLocationCoordinate2D = (thisPlacemark.location?.coordinate)!
            print(thisCoordinate)
            
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = thisCoordinate
            
            self.mapView.addAnnotation(annotation)
            
            let regionRadius: CLLocationDistance = 1000
            
            
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(thisCoordinate, regionRadius * 2.0, regionRadius * 2.0)
            self.mapView.setRegion(coordinateRegion, animated: true)
            self.mapView.centerCoordinate = thisCoordinate
            
            self.reloadInputViews()
            
            
        })

        mapView.hidden = false
        studentLocationPromptLabel.hidden = true
        studentLocationText.hidden = true
        findOnTheMapButton.hidden = true
        studentLinkText.hidden = false
        submitButton.hidden = false
    }
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        print(studentLinkText.text)
        print("submitButtonPressed")
        
        self.postStudentLocation()
        print("postStudentLocation completed")
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        print("cancelButtonPressed")
        navigationController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    private func postStudentLocation() {
        print("postStudentLocation")
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Jane\", \"lastName\": \"Doe\",\"mapString\": \"San Francisco, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print("rdata from postStudentLocation", data)

            print("response from postStudentLocation", response)
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
      
    }

}
