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
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        Students.allStudents.removeAll()
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        DBClient.sharedInstance().taskForGETMethod { (results, error) in
            
            if (error != nil) {
                OperationQueue.main.addOperation {
                    
                    let errorMsg  = error?.localizedDescription
                    
                    let uiAlertController = UIAlertController(title: "download error", message: errorMsg, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    uiAlertController.addAction(defaultAction)
                    self.present(uiAlertController, animated: true, completion: nil)
                }
            }
            
         //   let results = results?.object("results") as! NSArray
            
            let results = results?.object(forKey: "results") as! NSArray

            
            if Students.allStudents.count == 0 {
                for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
                    
                    self.setAnnotations(student: student)
                }
            }
            else {
                
                for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
                    
                    self.setAnnotations(student: student)
                }
                
                
                
            }
        }
        
    }
    
    
    func mapView(_ viewFormapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            
            let url = NSURL(string: ((view.annotation?.subtitle)!)!)!
            UIApplication.shared.openURL(url as URL)
            
            
        }
    }
    
    func performUIUpdatesOnMain(updates: @escaping () -> Void) {
      //  dispatch_async(dispatch_get_main_queue()) {
        //OperationQueue.main.addOperation {
        
        DispatchQueue.main.async {
            updates()

        }

   //         updates()
     //   }
        
    }
    
    func setAnnotations (student:Student) {
        var annotations = [MKPointAnnotation]()
        let lat1 = CLLocationDegrees(student.latitude)
        
        let long1 = CLLocationDegrees(student.longitude)
        
        let coordinate1 = CLLocationCoordinate2D(latitude: lat1, longitude: long1)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate1
        annotation.title = student.firstName! + " " + student.lastName!
        annotation.subtitle = student.url!
        
        annotations.append(annotation)
        
       // dispatch_async(dispatch_get_main_queue()) {
        
        DispatchQueue.main.async {

            self.mapView.addAnnotations(annotations)
            
        }
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        
        
        print("refreshAction")
        
        Students.allStudents.removeAll()
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        print("annotations removed")
        
        DBClient.sharedInstance().taskForGETMethod { (results, error) in
            
            print(results as Any)
            
            if (error != nil) {
                OperationQueue.main.addOperation {
                    
                    let errorMsg  = error?.localizedDescription
                    
                    let uiAlertController = UIAlertController(title: "download error", message: errorMsg, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    uiAlertController.addAction(defaultAction)
                    self.present(uiAlertController, animated: true, completion: nil)
                }
            }
            print("results after refresh", results as Any)
            let results = results?.object(forKey: "results") as! NSArray
            
            if Students.allStudents.count == 0 {
                for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
                    
                    self.setAnnotations(student: student)
                }
            }
            else {
                
                for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
                    
                    self.setAnnotations(student: student)
                }
                
            }
        }
    }
}




