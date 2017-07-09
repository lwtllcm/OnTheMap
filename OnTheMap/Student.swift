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
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var location: String?
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var url:String?
    var createdAt:String?
    var updatedAt:String?
    

    init(dictionary:[String: AnyObject]) {
        objectId = dictionary[DBClient.ParseResponseKeys.ObjectId] as? String
        uniqueKey = dictionary[DBClient.ParseResponseKeys.UniqueKey] as? String
        firstName = dictionary[DBClient.ParseResponseKeys.FirstName] as? String
        lastName = dictionary[DBClient.ParseResponseKeys.LastName] as? String
        location = dictionary[DBClient.ParseResponseKeys.MapString] as? String
        url = dictionary[DBClient.ParseResponseKeys.MediaURL] as? String
        latitude = (dictionary[DBClient.ParseResponseKeys.Latitude] as? Double)!
        longitude = (dictionary[DBClient.ParseResponseKeys.Longitude] as? Double)!
        
        createdAt = (dictionary[DBClient.ParseResponseKeys.CreatedAt] as? String)!
        updatedAt = (dictionary[DBClient.ParseResponseKeys.UpdatedAt] as? String)!
        }
    

    
    static func studentFromResults(_ results: [[String:AnyObject]] )-> [Student] {
        print("Student studentFromResults")

        for result in results as NSArray {
            
            
            if  let resultObjectId = (result as AnyObject).object(forKey: "objectId") {
                if let resultUniqueKey = (result as AnyObject).object(forKey: "uniqueKey") {
                    if let resultFirstName = (result as AnyObject).object(forKey: "firstName") {
                        if  let resultLastName = (result as AnyObject).object(forKey: "lastName") {
                            if     let resultLocation = (result as AnyObject).object(forKey: "mapString") {
                                if let resultURL = (result as AnyObject).object(forKey: "mediaURL") as? String {
                                    if  let resultLatitude = (result as AnyObject).object(forKey: "latitude") as? CLLocationDegrees {
                                        if     let resultLongitude = (result as AnyObject).object(forKey: "longitude") as? CLLocationDegrees {
                                            if   let resultCreatedAt = (result as AnyObject).object(forKey: "createdAt") {
                                                if    let resultUpdatedAt = (result as AnyObject).object(forKey: "updatedAt") {

            
            let newTestStudent = Student(dictionary: [DBClient.ParseResponseKeys.ObjectId:resultObjectId as AnyObject,
                DBClient.ParseResponseKeys.UniqueKey:resultUniqueKey as AnyObject,
                DBClient.ParseResponseKeys.FirstName:resultFirstName as AnyObject,
                DBClient.ParseResponseKeys.LastName:resultLastName as AnyObject,
                DBClient.ParseResponseKeys.MapString:resultLocation as AnyObject,
                DBClient.ParseResponseKeys.MediaURL:resultURL as AnyObject,
                DBClient.ParseResponseKeys.Latitude:resultLatitude as AnyObject,
                DBClient.ParseResponseKeys.Longitude:resultLongitude as AnyObject,
                DBClient.ParseResponseKeys.CreatedAt:resultCreatedAt as AnyObject,
                DBClient.ParseResponseKeys.UpdatedAt:resultUpdatedAt as AnyObject])

            
           print(newTestStudent.location as Any)
            Students.allStudents.append(newTestStudent)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        print(Students.allStudents)
        return Students.allStudents
    }

    


}

