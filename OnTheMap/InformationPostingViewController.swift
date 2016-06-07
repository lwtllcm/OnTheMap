//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/28/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
   
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
        
        studentLocationText.delegate = self
        studentLinkText.delegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("InformationPostingViewController")
        
        subscribeToKeyboardNotifications()
        subscribeToKeyboardWillHideNotifications()

            }
    
    override func viewWillDisappear(animated: Bool) {
        print("viewWillDisappear")
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
                print(error?.localizedDescription)
                let errorMsg  = error?.localizedDescription
                let uiAlertController = UIAlertController(title: "geocoding error", message: errorMsg, preferredStyle: .Alert)
                
                
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
    
        
       let jsonBody = "{\"uniqueKey\": \"1234\", \"\(DBClient.ParseResponseKeys.FirstName)\": \"\(studentFirstName)\", \"\(DBClient.ParseResponseKeys.LastName)\": \"\(studentLastName)\",\"\(DBClient.ParseResponseKeys.MapString)\": \"\(studentMapString)\", \"\(DBClient.ParseResponseKeys.MediaURL)\": \"\(studentMediaURL)\",\"\(DBClient.ParseResponseKeys.Latitude)\": \(studentLatitude), \"\(DBClient.ParseResponseKeys.Longitude)\": \(studentLongitude)}"
        
        
        DBClient.sharedInstance().taskForPOSTMethod(jsonBody) { (results, error) in
            print("taskForPostMethod")
            
            if (error != nil) {
                print(error?.localizedDescription)
                let errorMsg  = error?.localizedDescription
                
                let uiAlertController = UIAlertController(title: "post error", message: errorMsg, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
            }
            
            else {
                
                self.dismissViewControllerAnimated(true, completion: {})

            }
        }
        
        
        print("postStudentLocation completed")
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        print("cancelButtonPressed")
        navigationController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (studentLocationText.isFirstResponder()) {
            print("studentLocationText is FirstResponder")
          //  view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
        //else
        
            if (studentLinkText.isFirstResponder()) {
                print("studentLinkText is FirstResponder")

                view.frame.origin.y = getKeyboardHeight(notification) * -0.1
        }


    }
    
    func keyboardWillHide(notification: NSNotification) {
        if studentLocationText.isFirstResponder() {
            view.frame.origin.y = 0.0
        }
            
        else
            if studentLinkText.isFirstResponder() {
                view.frame.origin.y = 0.0
        }

    }
    func textFieldDidBeginEditing( textField: UITextField) {
        print("textFieldDidBeginEditing")
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        print("getKeyboardHeight")
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        print("subscribeToKeyboardNotifications")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications() {
        print("subscribeToKeyboardNotifications")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        print("unsubscribeFromKeyboardNotifications")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillHideNotifications() {
        print("unsubscribeFromKeyboardNotifications")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    
}
