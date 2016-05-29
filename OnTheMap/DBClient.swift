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
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod(completionHandlerForGET:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        print("taskForGETMethod")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&-order=updatedAt")!)
        
        request.addValue(ParseConstants.ParseParameterValues.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")

        request.addValue(ParseConstants.ParseParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")

        
        print("request", request)
        
        let session = NSURLSession.sharedSession()
        print("got session")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print("in task")
            print("error", error)
            
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

                sendError("There was an error with your request: \(error)")

                
                                
                return
            }
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {

                    sendError("Your request returned a status code other than 2xx!")

                return
            }
            
            guard let data = data else {

                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        task.resume()
        return task
        
    }
    
    
    
    
    func taskForPOSTMethod(jsonBody: String, completionHandlerForPOST:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

    print("postStudentLocation")
    
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
    request.HTTPMethod = "POST"
        
    request.addValue(ParseConstants.ParseParameterValues.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(ParseConstants.ParseParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        
        
    request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
    

    
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
    print("rdata from postStudentLocation", data)
    
    print("response from postStudentLocation", response)
        
        
        func displayError(error: String) {
            print("displayError")
            print(error)
            
            let userInfo = [NSLocalizedDescriptionKey: error]
            
            completionHandlerForPOST(result: nil, error:NSError( domain: "taskForPOSTMethod", code: 1, userInfo:userInfo))
            
            
        }
        
        func sendError(error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandlerForPOST(result: nil, error:NSError( domain: "taskForPOSTMethod", code: 1, userInfo:userInfo))
            
        }
        
        guard (error == nil) else {

            sendError("There was an error with your request: \(error)")
            
            
            
            return
        }
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {

            sendError("Your request returned a status code other than 2xx!")
            
            return
        }
        
        guard let data = data else {

            sendError("No data was returned by the request!")
            return
        }
    
        
        self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        
        }
        task.resume()
        return task
    }
        
    
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        print("convertDataWithCompletionHandler")
        var parsedResult: AnyObject!
        
        do {
            
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
    
 
    func taskForUdacityPOSTMethod(jsonBody: String, completionHandlerForPOST:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
    
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        request.HTTPMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
       
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print("rdata from postUdacity", data)
            
            print("response from postUdacity", response)
            
           
            print("postUdacity error", error)

            
            
            func displayError(error: String) {
                print("displayError")
                print(error)
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                
                completionHandlerForPOST(result: nil, error:NSError( domain: "taskForPOSTMethod", code: 1, userInfo:userInfo))
                
                
            }
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(result: nil, error:NSError( domain: "taskForPOSTMethod", code: 1, userInfo:userInfo))
                
            }
            
            guard (error == nil) else {

                sendError("There was an error with your request: \(error)")
                
                
                
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {

                sendError("Your taskForUdacityPOSTMethod request returned a status code other than 2xx!")
                
                return
            }
            
            guard let data = data else {

                sendError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5) )
            
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            
            
        }
        task.resume()
        return task

    }
    
    
    func taskForGetUserID(completionHandlerForGetUserID:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        var userID = defaults.stringForKey("Udacity.UserID")!
        
        print(userID)
        
        let requestUserID = NSMutableURLRequest(URL:NSURL(string:"https://www.udacity.com/api/users/\(userID)")!)
        print("requestUserID", requestUserID)

        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(requestUserID) { data,response, error in
            
            print("response from taskForGetUserID", response)
            
            
            print("error from taskForGetUserID", error)
            
            
            
            func displayError(error: String) {
                print("displayError")
                print(error)
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                
                completionHandlerForGetUserID(result: nil, error:NSError( domain: "taskForGetUserID", code: 1, userInfo:userInfo))
                
                
            }
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGetUserID(result: nil, error:NSError( domain: "taskForGetUserID", code: 1, userInfo:userInfo))
                
            }
            
            guard (error == nil) else {

                sendError("There was an error with your request: \(error)")
                
                
                
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {

                sendError("Your taskForGetUserID request returned a status code other than 2xx!")
                
                return
            }
            
            guard let data = data else {

                sendError("No data was returned by the request!")
                return
            }
            
            print("taskForGetUserID successful")
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5) )
            
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGetUserID)
            
            
        }
        task.resume()
        return task
    }
 
    
}
