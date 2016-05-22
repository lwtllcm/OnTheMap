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
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?-order=updatedAt")!)
        
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
    
    
    
    
    func taskForPOSTMethod(jsonBody: String, completionHandlerForPOST:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

    //unc postStudentLocation() {
    print("postStudentLocation")
    
    
    //var newStudent:Student
    //newStudent.firstName = studentLinkText.text
    //newStudent.lastName = " "
    //newStudent.location = " "
    //newStudent.latitude = self.latitude
    //newStudent.longitude = self.longitude
    
    
    //print("newStudent", newStudent.firstName, newStudent.lastName, newStudent.latitude, newStudent.longitude)
    
    
    
    //let thisStudent =
    //Student(firstName:studentLinkText.text!  , lastName:" " , location:" " ,latitude: self.latitude, longitude: self.longitude, url: studentLinkText.text! as String, updatedAt: NSCalendar.currentCalendar())
    //print("thisStudent", thisStudent)
    
    
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
    request.HTTPMethod = "POST"
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        
    //request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Holly\", \"lastName\": \"Doe\",\"mapString\": \"Sacremento, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        
    request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
    
    //request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Jane\", \"lastName\": \"Doe\",\"mapString\": \"San Francisco, CA\", \"mediaURL\": ".dataUsingEncoding(NSUTF8StringEncoding)
    //request.HTTPBody.append(thisStudent.url?.dataUsingEncoding(NSUTF8StringEncoding))
    //request.HTTPBody.append(\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding))
    
    
    /*
    var requestURLString = "{\"uniqueKey\": \"1234\", \"firstName\": \"Jane\", \"lastName\": \"Doe\",\"mapString\": \"San Francisco, CA\", \"mediaURL\": "
    requestURLString = requestURLString + thisStudent.url!
    requestURLString = requestURLString + ",\"latitude\": 37.386052, \"longitude\": -122.083851}"
    request.HTTPBody = requestURLString.dataUsingEncoding(NSUTF8StringEncoding)
    print("request.HTTPBody", request.HTTPBody)
    */
    
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
    
        
        
        
        /*
    if error != nil {
    
    
    let uiAlertController = UIAlertController(title: "post error", message: nil, preferredStyle: .Alert)
    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    uiAlertController.addAction(defaultAction)
    self.presentViewController(uiAlertController, animated: true, completion: nil)
    self.activityIndicator.alpha = 0.0
    self.activityIndicator.stopAnimating()
    
    
    return
    }
*/
        
   // print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        
        /*
    }
    task.resume()
    */
        
        self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    //private func getRequestToken() {
    func taskForUdacityPOSTMethod(jsonBody: String, completionHandlerForPOST:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
    
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        request.HTTPMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       // let httpBodyString = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}"
        
        
        //request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Holly\", \"lastName\": \"Doe\",\"mapString\": \"Sacremento, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        //request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Jane\", \"lastName\": \"Doe\",\"mapString\": \"San Francisco, CA\", \"mediaURL\": ".dataUsingEncoding(NSUTF8StringEncoding)
        //request.HTTPBody.append(thisStudent.url?.dataUsingEncoding(NSUTF8StringEncoding))
        //request.HTTPBody.append(\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding))
        
        
        /*
        var requestURLString = "{\"uniqueKey\": \"1234\", \"firstName\": \"Jane\", \"lastName\": \"Doe\",\"mapString\": \"San Francisco, CA\", \"mediaURL\": "
        requestURLString = requestURLString + thisStudent.url!
        requestURLString = requestURLString + ",\"latitude\": 37.386052, \"longitude\": -122.083851}"
        request.HTTPBody = requestURLString.dataUsingEncoding(NSUTF8StringEncoding)
        print("request.HTTPBody", request.HTTPBody)
        */
        
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
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5) )
            
            /*
            if error != nil {
            
            
            let uiAlertController = UIAlertController(title: "post error", message: nil, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            uiAlertController.addAction(defaultAction)
            self.presentViewController(uiAlertController, animated: true, completion: nil)
            self.activityIndicator.alpha = 0.0
            self.activityIndicator.stopAnimating()
            
            
            return
            }
            */
            
            // print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            /*
            }
            task.resume()
            */
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        task.resume()
        return task
        /*
        print("getRequestToken")
      
        let methodParameters : [String:AnyObject] =  [
            
            UdacityParameterKeys.Username:emailTextField.text!,
            UdacityParameterKeys.Password:passwordTextField.text!
        ]
        
        print("methodParameters", methodParameters)

        
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(methodParameters,withPathExtension: nil))
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBodyString = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}"
        print("request httpbody: \(httpBodyString)")
        
        request.HTTPBody = httpBodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        print("request",request)
        
        let task = appDelegate.sharedSession.dataTaskWithRequest(request) { (data, response, error) in
            
            print("error" , error)
            
            let parsedResult: AnyObject!
            do {
                print("data to parse", data)
                let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5))
                print("newData", NSString(data: newData!, encoding: NSUTF8StringEncoding))
                
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData!, options: .AllowFragments)
                print("parsedResult", parsedResult)
                self.getUserID()
                
            }
            catch {
                
                print("Could not parse the data as JSON: '\(data)'")
                
                return
            }
            
        }
        
        task.resume()
*/
    }
    
    /*
    private func loginWithToken(requestToken:String) {
    
    }
    */
    
    
    /*
    func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        print("udacityURLFromParameters")
        let components = NSURLComponents()
        
        components.scheme = "https"
        components.host = "udacity.com"
        components.path = "/api/session" + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    private func getUserID() {
        print("getUserID")
        
        let requestUserID = NSMutableURLRequest(URL:NSURL(string:"https://www.udacity.com/api/users/me")!)
        
        let task = appDelegate.sharedSession.dataTaskWithRequest(requestUserID) { (data, response, error) in
            
            print("error" , error)
            print("data", data)
            print("response", response)
            
            print("response for getUserID", response)
            
            let parsedResult: AnyObject!
            do {
                print("data to parse", data)
                let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5))
                print("newData", NSString(data: newData!, encoding: NSUTF8StringEncoding))
                
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData!, options: .AllowFragments)
                print("parsedResult", parsedResult)
                
            }
            catch {
                
                print("Could not parse the data as JSON: '\(data)'")
                
                let uiAlertController = UIAlertController(title: "loginAlert", message: "login failed", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
                
                return
            }
            
        }
        
        task.resume()
    }
*/
    
    
    
    
    
}
