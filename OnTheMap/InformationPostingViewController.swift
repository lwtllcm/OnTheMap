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
        mapView.isHidden = true
        studentLocationPromptLabel.isHidden = false
        studentLinkText.isHidden = true
        submitButton.isHidden = true
        activityIndicator.isHidden = true
        
        studentLocationText.delegate = self
        studentLinkText.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("InformationPostingViewController")
        
        subscribeToKeyboardNotifications()
        subscribeToKeyboardWillHideNotifications()

            }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func studentLocationTextAction(_ sender: AnyObject) {
        print("studentLocationText entered")
       
    }
    
    @IBAction func findOnTheMapButtonPressed(_ sender: AnyObject) {
        print("Find on the Map pressed")
        print(studentLocationText)
        
        activityIndicator.isHidden = false
        activityIndicator.alpha = 1.0
        
        activityIndicator.startAnimating()
        
        let geocoder = CLGeocoder()
        

        geocoder.geocodeAddressString(studentLocationText.text!, completionHandler: {placemarks, error in

            
            if (error != nil) {
                print("geocoding error")
                print(error?.localizedDescription)
                let errorMsg  = error?.localizedDescription
                let uiAlertController = UIAlertController(title: "geocoding error", message: errorMsg, preferredStyle: .alert)
                
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.present(uiAlertController, animated: true, completion: nil)
                self.activityIndicator.alpha = 0.0
                self.activityIndicator.stopAnimating()

                
            }
            else {
            
            let thisPlacemark = placemarks![0]
            print(thisPlacemark)
            print(thisPlacemark.location as Any)
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
            
            
                
           self.mapView.isHidden = false
           self.studentLocationPromptLabel.isHidden = true
                self.studentLocationText.isHidden = true
                self.findOnTheMapButton.isHidden = true
                self.studentLinkText.isHidden = false
                self.submitButton.isHidden = false
                
            self.reloadInputViews()
                
                
            }
            
        })
    }
    
    
    @IBAction func submitButtonPressed(_ sender: AnyObject) {
        print(studentLinkText.text as Any)
        print("submitButtonPressed")
        
        
        let defaults = UserDefaults.standard

              let studentMediaURL = studentLinkText.text! as String
        let studentFirstName = defaults.string(forKey: "Udacity.FirstName")!
        let studentLastName = defaults.string(forKey: "Udacity.LastName")!
        let studentLatitude = self.latitude
        let studentLongitude = self.longitude

        let studentMapString = studentLocationText.text! as String
        
        let jsonBody = "{\"uniqueKey\": \"1234\", \"\(DBClient.ParseResponseKeys.FirstName)\": \"\(studentFirstName)\", \"\(DBClient.ParseResponseKeys.LastName)\": \"\(studentLastName)\",\"\(DBClient.ParseResponseKeys.MapString)\": \"\(studentMapString)\", \"\(DBClient.ParseResponseKeys.MediaURL)\": \"\(studentMediaURL)\",\"\(DBClient.ParseResponseKeys.Latitude)\": \(studentLatitude),\"\(DBClient.ParseResponseKeys.Longitude)\": \(studentLongitude)}"
        
        print(jsonBody)

        
        DBClient.sharedInstance().taskForPOSTMethod(jsonBody) { (results, error) in
            print("taskForPostMethod")
            print(results as Any)
            
            if (error != nil) {
                print(error?.localizedDescription as Any)
                let errorMsg  = error?.localizedDescription
                
                let uiAlertController = UIAlertController(title: "post error", message: errorMsg, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.present(uiAlertController, animated: true, completion: nil)
            }
            
            else {
                
                self.dismiss(animated: true, completion: {})

            }
        }
        
        
        print("postStudentLocation completed")
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        print("cancelButtonPressed")
        navigationController?.dismiss(animated: true, completion: {})
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if (studentLocationText.isFirstResponder) {
            print("studentLocationText is FirstResponder")
          //  view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
        //else
        
            if (studentLinkText.isFirstResponder) {
                print("studentLinkText is FirstResponder")

                view.frame.origin.y = getKeyboardHeight(notification) * -0.1
        }


    }
    
    func keyboardWillHide(_ notification: Notification) {
        if studentLocationText.isFirstResponder {
            view.frame.origin.y = 0.0
        }
            
        else
            if studentLinkText.isFirstResponder {
                view.frame.origin.y = 0.0
        }

    }
    func textFieldDidBeginEditing( _ textField: UITextField) {
        print("textFieldDidBeginEditing")
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        print("getKeyboardHeight")
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        print("subscribeToKeyboardNotifications")
        NotificationCenter.default.addObserver(self, selector: #selector(InformationPostingViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications() {
        print("subscribeToKeyboardNotifications")
        NotificationCenter.default.addObserver(self, selector: #selector(InformationPostingViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        print("unsubscribeFromKeyboardNotifications")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardWillHideNotifications() {
        print("unsubscribeFromKeyboardNotifications")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    
}
