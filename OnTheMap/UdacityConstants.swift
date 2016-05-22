//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/20/16.
//  Copyright © 2016 Student. All rights reserved.
//

    struct UdacityConstants {
    
        //static let ApiKey : String = "***"
        //static let ApiPassword : String = "*****"
        
        static let ApiScheme = "http"
        static let ApiHost = "udacity.com"
        static let ApiPath = "/student"
        
        static let AuthorizationURL : String = "****"
    }
    
    struct UdacityParameterKeys {
        static let ApiKey = "api_key"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
        static let Format = "format"
        
    }
    
    struct UdacityParameterValues {
        static let ApiKey = "api_key"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
        static let ResponseFormat = "json"
    }

struct UdacityJSONResponseKeys {
    static let Account = "account"
    static let UserID = "X-Udacity-Account-Id"
}

    

