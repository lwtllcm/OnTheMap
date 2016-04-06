//
//  Student.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/13/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

struct Student {
   var name: String
   var location: String
    

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
    
 
    }


    
    static func studentFromResults(results: [[String:AnyObject]] )-> [Student] {
        var students = [Student] ()
        for result in results {
        students.append(Student(dictionary: result))
        }
        
        return students
    }
}
