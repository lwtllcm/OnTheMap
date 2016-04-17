//
//  Student.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/13/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

struct Student {
   var name: String?
   var location: String?


    
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
        var testStudents = [Student] ()
        for result in results as NSArray {
            print("result", result)
            print("result firstName", result.objectForKey("firstName"))
            print("result location", result.objectForKey("mapString"))
            let resultName = result.objectForKey("firstName")
            print("resultName", resultName)
            let resultLocation = result.objectForKey("updatedAt")
            print("resultLocation", resultLocation)
            
            let newTestStudent = Student(name:resultName as? String, location:resultLocation as? String)
            print("newTestStudent", newTestStudent)
            testStudents.append(newTestStudent)
            print(testStudents)
        }
        return testStudents
    }

    


}

