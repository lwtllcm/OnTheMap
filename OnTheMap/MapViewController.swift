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
   
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController viewDidLoad")
        
        DBClient.sharedInstance().taskForGETMethod { (results, error) in
            print("taskForGetMethod")
            print("results from taskForGETMethod", results)
            
            if (error != nil) {
                
                let uiAlertController = UIAlertController(title: "download error", message: nil, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
            }

            
            let results = results.objectForKey("results") as! NSArray
            
            if Students.allStudents.count == 0 {
                for student in Student.studentFromResults(results as! [[String : AnyObject]]) {

                self.setAnnotations(student)
            }
            }
            else {
                for student in Students.allStudents {
                    
                    self.setAnnotations(student)
            }
            
            /*
           
            var annotations = [MKPointAnnotation]()
            
            for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
                
                
                let lat1 = CLLocationDegrees(student.latitude)
                print("lat1", lat1)
                
                let long1 = CLLocationDegrees(student.longitude)
                print("long1", long1)
                let coordinate1 = CLLocationCoordinate2D(latitude: lat1, longitude: long1)
                print("coordinate1", coordinate1)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate1
                annotation.title = student.firstName! + " " + student.lastName!
                annotation.subtitle = student.url!
                print("annotation.title", annotation.title)
                
                
                annotations.append(annotation)
                
            }


            print("annotations", annotations)

            dispatch_async(dispatch_get_main_queue()) {
                self.mapView.addAnnotations(annotations)
*/
            }
        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("MapViewController viewWillAppear")
     
}
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("mapView viewForAnnotation")
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.redColor()
            pinView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
 
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
        if control == view.rightCalloutAccessoryView {
            
           
            let url = NSURL(string: ((view.annotation?.subtitle)!)!)!
            UIApplication.sharedApplication().openURL(url)
            
            
        }
    }
    
     func performUIUpdatesOnMain(updates: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            updates()
        }
    }
    
    func setAnnotations (student:Student) {
        var annotations = [MKPointAnnotation]()
        let lat1 = CLLocationDegrees(student.latitude)
        print("lat1", lat1)
        
        let long1 = CLLocationDegrees(student.longitude)
        print("long1", long1)
        let coordinate1 = CLLocationCoordinate2D(latitude: lat1, longitude: long1)
        print("coordinate1", coordinate1)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate1
        annotation.title = student.firstName! + " " + student.lastName!
        annotation.subtitle = student.url!
        print("annotation.title", annotation.title)
        
        
        annotations.append(annotation)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.addAnnotations(annotations)

    }
    }
}