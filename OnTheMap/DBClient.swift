//
//  DBClient.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 4/27/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class DBClient {
    
    var session = URLSession.shared
    
    
    class  func sharedInstance() -> DBClient {
        struct Singleton {
            static let sharedInstance = DBClient()
            
            fileprivate init() {}
        }
        return Singleton.sharedInstance
    }
    
    
    func taskForGETMethod(_ completionHandlerForGET:@escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //let request = NSMutableURLRequest(url: URL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&-order=updatedAt")!)
        
       // var request = URLRequest(url: URL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&-order=updatedAt")!)
        
        //var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&-order=updatedAt")!)
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=3")!)

        
        request.addValue(ParseConstants.ParseParameterValues.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")

        request.addValue(ParseConstants.ParseParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        

        //request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        //request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        print(request)
        
        //let session = NSURLSession.sharedSession()
        
     //   let task = session.dataTask(with: request, completionHandler: { data, response, error in
            

       // let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        
       // let task = session.dataTask(with: request) { (data, response, error ) in
        let task = session.dataTask(with: request as URLRequest) { (data, response, error ) in

            print("in task")
             print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
           // print(data as Any)
            print("error", error as Any)
            
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError( domain: "taskForGETMethod", code: 1, userInfo:userInfo))
                
            }
            /*
            if error != nil
            {
                sendError((error?.localizedDescription)!)
                return
            }
            */
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            
            
            if data == nil {
                sendError("Error retrieving data")
                return
            }
            
            /*
            guard (data == nil) else {
                sendError("Error retrieving data")
                return
            }
 */
            print("ready to convert Parse data")
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForGET)
            
        } 
        task.resume()
        return task
        
    }
    
    
    func taskForPOSTMethod(_ jsonBody: String, completionHandlerForPOST:@escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {

    
    //let request = NSMutableURLRequest(url: URL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        
        var request = URLRequest(url: URL(string: "https://api.parse.com/1/classes/StudentLocation")!)

    request.httpMethod = "POST"
        
    request.addValue(ParseConstants.ParseParameterValues.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(ParseConstants.ParseParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
    //let session = NSURLSession.sharedSession()
        
        
   // let task = session.dataTask(with: request, completionHandler: { data, response, error in
        
        //let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

       let task = session.dataTask(with: request, completionHandler: { data, response, error in
        
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandlerForPOST(nil, NSError( domain: "taskForPOSTMethod", code: 1, userInfo:userInfo))
            
        }
       /*
        if error != nil
        {
            sendError((error?.localizedDescription)!)
            return
        }
 */
        guard (error == nil) else {
            sendError((error?.localizedDescription)!)
            return
        }
        
        /*
        if data == nil {
            sendError("Parse update error ")
            return
        }
*/
        guard (data == nil) else {
            sendError("Parse update error ")
            return
        }
        
        self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForPOST)
        
        }) 
        task.resume()
        return task
    }
        
    func taskForUdacityPOSTMethod(_ jsonBody: String, completionHandlerForPOST:@escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        //let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)

        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        
//        let session = NSURLSession.sharedSession()
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            print("postUdacity error", error as Any)
            print(response)
            
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                //completionHandlerForPOST(result: nil, error:NSError( domain: "taskForUdacityPOSTMethod", code: 1, userInfo:userInfo))
                completionHandlerForPOST(nil, NSError( domain: "taskForUdacityPOSTMethod", code: 1, userInfo:userInfo))
                
            }
            /*
            func checkForTimedOut() {
                let code = (error as! NSError).code
               // guard (error?.code == NSURLErrorTimedOut) else {
                guard (code == NSURLErrorTimedOut) else {
                    return
                }
                
                print("timed out")
                sendError("Request timed out")
                
                return
            }
            
 
            checkForTimedOut()
            */
            /*
            if error != nil
            {
                sendError((error?.localizedDescription)!)
                return
            }
 */
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            
            /*
            if data == nil {
                sendError("User / Password error ")
                return
            }
 */
            
            guard (error == nil) else {
                sendError("User / Password error ")
                return
            }
            
            
            //let newData = data!.subdata(in: NSMakeRange(5, data!.count - 5) )
            
            
            
            //let newData = data!.subdata(in: 5..<data!.count - 5 )
            
            let newData = data!.subdata(in: 5..<data!.count )

            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            
            
        }) 
        task.resume()
        return task
        
    }
    
    
    func taskForGetUserID(_ userID: String, completionHandlerForGetUserID:@escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
       // let requestUserID = NSMutableURLRequest(url:URL(string:"https://www.udacity.com/api/users/\(userID)")!)
        
        var requestUserID = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)

        print("requestUserID", requestUserID)
        
        
        let task = session.dataTask(with: requestUserID, completionHandler: { data,response, error in
            
            
            func sendError(_ error: String) {

                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGetUserID(nil, NSError( domain: "taskForGetUserID", code: 1, userInfo:userInfo))
                
            }
            
            /*
            if error != nil
            {
                sendError((error?.localizedDescription)!)
                return
            }
 */
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            
            /*
            if data == nil {
                sendError("User / Password error ")
                return
            }
 */
            
            guard (error == nil) else {
                sendError("User / Password error ")
                return
            }

            
           // let myRange = NSRange(location: 5, length: data!.count - 5)
            
           // let newData = data!.subdata(in: NSMakeRange(5, data!.count - 5) )
            
            //let range = Range(uncheckedBounds: 5, data!.count - 5)
            let newData = data!.subdata(in: 5..<data!.count  )

            
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGetUserID)
            
            
        }) 
        task.resume()
        return task
    }
    
    
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        print("convertDataWithCompletionHandler")

        //var parsedResult: AnyObject!
        var parsedResult: [String:AnyObject]!
        
        do {
            
            
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            
            
        }
        catch {
            //let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            
            print("Could not parse the data as JSON: '\(data)'")
            //completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        //completionHandlerForConvertData(parsedResult as AnyObject?, nil)
        completionHandlerForConvertData(parsedResult  as AnyObject?, nil)

    }
    
    
}
