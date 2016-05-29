//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/20/16.
//  Copyright © 2016 Student. All rights reserved.
//
extension DBClient {

struct ParseConstants {
    struct ParseDB {
        static let ApiScheme = "http"
        static let ApiHost = "parse.com"
        static let ApiPath = "/student"
    }
    
    struct ParseParameterKeys {
        static let ApiKey = "api_key"
        static let RequestToken = "request_token"
        static let ApplicationID = "application_id"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct ParseParameterValues {
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let RequestToken = "request_token"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
}
    
    struct ParseResponseKeys {

        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"

        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        static let UserID = "id"
        
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
    
}
