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
   var name: String?
   var location: String?
    
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    //var location: String?
   //var url:NSURL?
    var url:String?

    
 /*
init(dictionary: [String:AnyObject]) {
    name = "name"
    location = "location"
 
    
   
    //print(dictionary)
    //print(dictionary[name])
    //print(dictionary[location])
    
    name = (dictionary["name"] as? String)!
    location = (dictionary["location"] as? String)!
    //print("name ", name)
    //print("location ", location)
    
    
    print("init dictionary", dictionary)
 
    }

*/
    
    static func studentFromResults(results: [[String:AnyObject]] )-> [Student] {
        print("Student studentFromResults")
        var testStudents = [Student] ()
        for result in results as NSArray {
            print("result", result)
            print("result firstName", result.objectForKey("firstName"))
            print("result location", result.objectForKey("mapString"))
            
            
            
            let resultName = result.objectForKey("firstName")
            let resultLocation = result.objectForKey("mapString")
            let resultLatitude = result.objectForKey("latitude") as! CLLocationDegrees
            let resultLongitude = result.objectForKey("longitude") as! CLLocationDegrees

            
            let resultURL = result.objectForKey("mediaURL") as! String
            print("resultURL", resultURL)
            
           
            //let newTestStudent = Student(name:resultName as? String, location:resultLocation as? String,url: resultURL as String)
            let newTestStudent =
            Student(name:resultName as! String , location:resultLocation as! String ,latitude: resultLatitude, longitude: resultLongitude, url: resultURL as String)
                       
            print("newTestStudent", newTestStudent)
            testStudents.append(newTestStudent)
            print(testStudents)
            
        }
        return testStudents
    }

    


}

