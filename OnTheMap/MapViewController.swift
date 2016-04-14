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
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController viewDidLoad")
        
        let locations = testLocationData()
        
        var annotations = [MKPointAnnotation]()
        
        for dictionary in locations {
            
            //let lat = CLLocationDegrees(dictionary["latititude"] as! Double)
            let lat = CLLocationDegrees(38.1461248)
            
            //let long = CLLocationDegrees(dictionary["longititude"] as! Double)
            let long = CLLocationDegrees(-92.75676799999999)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            //let first = dictionary["firstName"] as! String
            //let last = dictionary["lastName"] as! String
            //let mediaURL = dictionary["medaURL"] as! String

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Coordinate"
            
            annotations.append(annotation)
            
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        print("MapViewController viewWillAppear")
        
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
    
}