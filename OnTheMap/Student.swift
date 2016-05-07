//
//  Student.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/13/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import MapKit

struct Student {
    var firstName: String?
    var lastName: String?
    var location: String?
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var url:String?
    
    init(firstName: String, lastName: String, location: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, url: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.url = url
    }

 
    
    static func studentFromResults(results: [[String:AnyObject]] )-> [Student] {
        print("Student studentFromResults")
        var allStudents = [Student] ()
        for result in results as NSArray {
            
            //print("result", result)
            //print("result firstName", result.objectForKey("firstName"))
            //print("result location", result.objectForKey("mapString"))
            
            let resultFirstName = result.objectForKey("firstName")
            let resultLastName = result.objectForKey("lastName")
            let resultLocation = result.objectForKey("mapString")
            let resultLatitude = result.objectForKey("latitude") as! CLLocationDegrees
            let resultLongitude = result.objectForKey("longitude") as! CLLocationDegrees

            
            let resultURL = result.objectForKey("mediaURL") as! String
            //print("resultURL", resultURL)
            
           
            let newTestStudent =
            Student(firstName:(resultFirstName as? String)! , lastName:(resultLastName as? String)! , location:(resultLocation as? String)! ,latitude: resultLatitude, longitude: resultLongitude, url: resultURL as String)
                       
            //print("newTestStudent", newTestStudent)
            allStudents.append(newTestStudent)
            //print(allStudents)
            
        }
        return allStudents
    }

    


}

