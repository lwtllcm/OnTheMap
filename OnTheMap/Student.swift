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
    

    
    static func studentFromResults(results: [[String:AnyObject]] )-> [Student] {
        print("Student studentFromResults")

        for result in results as NSArray {
            
            
            let resultObjectId = result.objectForKey("objectId")
            let resultUniqueKey = result.objectForKey("uniqueKey")
            let resultFirstName = result.objectForKey("firstName")
            let resultLastName = result.objectForKey("lastName")
            let resultLocation = result.objectForKey("mapString")
            let resultURL = result.objectForKey("mediaURL") as! String
            let resultLatitude = result.objectForKey("latitude") as! CLLocationDegrees
            let resultLongitude = result.objectForKey("longitude") as! CLLocationDegrees
            let resultCreatedAt = result.objectForKey("createdAt")
             let resultUpdatedAt = result.objectForKey("updatedAt")

            
            let newTestStudent = Student(dictionary: [DBClient.ParseResponseKeys.ObjectId:resultObjectId!,
                DBClient.ParseResponseKeys.UniqueKey:resultUniqueKey!,
                DBClient.ParseResponseKeys.FirstName:resultFirstName!,
                DBClient.ParseResponseKeys.LastName:resultLastName!,
                DBClient.ParseResponseKeys.MapString:resultLocation!,
                DBClient.ParseResponseKeys.MediaURL:resultURL,
                DBClient.ParseResponseKeys.Latitude:resultLatitude,
                DBClient.ParseResponseKeys.Longitude:resultLongitude,
                DBClient.ParseResponseKeys.CreatedAt:resultCreatedAt!,
                DBClient.ParseResponseKeys.UpdatedAt:resultUpdatedAt!])

            
            print(Students.allStudents)
            Students.allStudents.append(newTestStudent)
            
        }
        return Students.allStudents
    }

    


}

