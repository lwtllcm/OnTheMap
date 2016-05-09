//
//  DBClient.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 4/27/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class DBClient: NSObject {
    
    var session = NSURLSession.sharedSession()
    
    //var allStudents:[Student] = [Student]()
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod(completionHandlerForGET:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        print("taskForGETMethod")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?order=updatedAt")!)
        
        //request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseConstants.ParseParameterValues.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")

        //request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(ParseConstants.ParseParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")

        
        print("request", request)
        
        let session = NSURLSession.sharedSession()
        print("got session")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print("in task")
            print("error", error)
            print("data", data)
            
            func displayError(error: String) {
                print("displayError")
                print(error)
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                
                completionHandlerForGET(result: nil, error:NSError( domain: "taskForGETMethod", code: 1, userInfo:userInfo))
                
                
            }
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(result: nil, error:NSError( domain: "taskForGETMethod", code: 1, userInfo:userInfo))
                
            }
            
            guard (error == nil) else {
                //displayError("There was an error with your request: \(error)")
                sendError("There was an error with your request: \(error)")

                
                                
                return
            }
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                //displayError("Your request returned a status code other than 2xx!")
                sendError("Your request returned a status code other than 2xx!")

                return
            }
            
            guard let data = data else {
               // displayError("No data was returned by the request!")
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        task.resume()
        return task
        
    }
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        print("convertDataWithCompletionHandler")
        var parsedResult: AnyObject!
        
        do {
            
            let newData = data.subdataWithRange(NSMakeRange(5, (data.length) - 5))
            print("newData", newData)
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            
            
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
        

    }
    
    
    
    class  func sharedInstance() -> DBClient {
        struct Singleton {
            static var sharedInstance = DBClient()
        }
        return Singleton.sharedInstance
    }
    
}
