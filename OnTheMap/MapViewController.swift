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
            print("MapViewController finished taskForGETMethod")
            
            if (error != nil) {
                OperationQueue.main.addOperation {
                    
                    let errorMsg  = error?.localizedDescription
                    
                    let uiAlertController = UIAlertController(title: "download error", message: errorMsg, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    uiAlertController.addAction(defaultAction)
                    self.present(uiAlertController, animated: true, completion: nil)
                }
            }
            
            print("results ready to parse")
            let results = results?.object(forKey: "results") as! NSArray
            
            print(results)
            
            if Students.allStudents.count == 0 {
                for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
                    
                    //self.setAnnotations(student)
                    
                    setAnnotations(student)
                }
            }
            else {
                
                for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
                    
                    //self.setAnnotations(student)
                    setAnnotations(student)
                }
                
                
                
            }
        }
     
}
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
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
            
           
            let url = URL(string: ((view.annotation?.subtitle)!)!)!
            UIApplication.shared.openURL(url)
            
            
        }
    }
    
    // func performUIUpdatesOnMain(_ updates: @escaping @escaping @escaping @escaping @escaping @escaping @escaping @escaping @escaping @escaping () -> Void) {
        
       // func performUIUpdatesOnMain(_ updates: @escaping @escaping @escaping @escaping @escaping @escaping @escaping @escaping @escaping @escaping () -> Void) {
            
            func performUIUpdatesOnMain(_ updates: @escaping  () -> Void) {
        //DispatchQueue.main.async {
           // Closure use of non-escaping parameter 'updates'may allow it to escape
            //parameter 'updates' is implicitly non-escaping
            
            //updates()
        }
    }
    
    func setAnnotations (_ student:Student) {
        var annotations = [MKPointAnnotation]()
        let lat1 = CLLocationDegrees(student.latitude)
        
        let long1 = CLLocationDegrees(student.longitude)

        let coordinate1 = CLLocationCoordinate2D(latitude: lat1, longitude: long1)

        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate1
        annotation.title = student.firstName! + " " + student.lastName!
        annotation.subtitle = student.url!
        
        annotations.append(annotation)
        
        DispatchQueue.main.async {
            //self.mapView.addAnnotations(annotations)
            let thisMapView = MKMapView()
            thisMapView.addAnnotations(annotations)

            

    }
    }
    
    // refreshAction
    
    func refreshAction(_ sender: AnyObject) {
        
       Students.allStudents.removeAll()
        
        //let allAnnotations = self.mapView.annotations
        let allAnnotations = MKMapView.annotations
        
        //self.mapView.removeAnnotations(allAnnotations)
        //mapView.removeAnnotations(allAnnotations)
        
        
        DBClient.sharedInstance().taskForGETMethod { (results, error) in
        
        if (error != nil) {
        OperationQueue.main.addOperation {
        
        let errorMsg  = error?.localizedDescription
        
        let uiAlertController = UIAlertController(title: "download error", message: errorMsg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        uiAlertController.addAction(defaultAction)
        //self.present(uiAlertController, animated: true, completion: nil)
            uiAlertController.present(uiAlertController, animated: true, completion: nil)
            
         
        }
        }
        
        let results = results?.object(forKey: "results") as! NSArray
        
        if Students.allStudents.count == 0 {
        for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
        
        //self.setAnnotations(student)
            setAnnotations(student)
        }
        }
        else {
        
        for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
        
        //self.setAnnotations(student)
            setAnnotations(student)
        }
        
               
        }
        }


    }

