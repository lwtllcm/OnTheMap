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
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.hidden = true
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
        
        var geocoder = CLGeocoder()
        var placemarks = [CLPlacemark]()
        

        geocoder.geocodeAddressString(studentLocationText.text!, completionHandler: {placemarks, error in
            //print(placemarks)
            var thisPlacemark = placemarks![0]
            print(thisPlacemark)
            print(thisPlacemark.location)
            var thisCoordinate:CLLocationCoordinate2D = (thisPlacemark.location?.coordinate)!
            print(thisCoordinate)
            
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = thisCoordinate
            //annotation.title = student.url
            
            
            self.mapView.addAnnotation(annotation)
            
            let regionRadius: CLLocationDistance = 1000
            
            //https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
            
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(thisCoordinate, regionRadius * 2.0, regionRadius * 2.0)
            self.mapView.setRegion(coordinateRegion, animated: true)
            self.mapView.centerCoordinate = thisCoordinate
            
            //self.mapView.center.x = thisCoordinate.latitude as! CGFloat
            //self.mapView.center.y = thisCoordinate.longitude as! CGFloat
            
            //self.mapView.center.x = 48.8567879
            //self.mapView.center.y = 2.3510768
            
            self.reloadInputViews()
        

            
            
        })

        
        /*
        //http://stackoverflow.com/questions/31798843/swift-completion-handler-for-reverse-geocoding
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(<#T##location: CLLocation##CLLocation#>, completionHandler: <#T##CLGeocodeCompletionHandler##CLGeocodeCompletionHandler##([CLPlacemark]?, NSError?) -> Void#>)
        geocoder.geocodeAddressString(studentLocationText.text!, completionHandler: {(placemarks:[AnyObject]!, error:NSError!) -> Void in
            if (placemarks.count > 0) {
            print(place)
            }
            ))
         */
        
        //var geocoder = CLGeocoder()
        //geocoder.geocodeAddressString(location: studentLocationText.text!, completionHandler: {(placemarks: [AnyObject],error:NSError!) -> Void in
          
        //})
        
        //geocoder.geocodeAddressString(location: studentLocationText.text!, completionHandler: {(placemarks: [AnyObject],error:NSError!) -> Void in
            
        //})
        
        //geocoder(studentLocationText)
        //studentLocationText.text.
            
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
    }
    
}
