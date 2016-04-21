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
    
    @IBOutlet weak var studentLocationText: UITextField!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("InformationPostingViewController")
        
    }
    @IBAction func studentLocationTextAction(sender: AnyObject) {
        print("studentLocationText entered")
    }
    
    @IBAction func findOnTheMapButtonPressed(sender: AnyObject) {
        print("Find on the Map pressed")
        mapView.hidden = false
    }
    
    
    
}
