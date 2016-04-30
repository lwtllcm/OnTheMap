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
    
    var testStudents:[Student] = [Student]()
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod(completionHandlerForGET:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        print("taskForGETMethod")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
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
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
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
            
            
            /*
            print("parsedResult", parsedResult)
            let thisParsedResultGroup = parsedResult.objectForKey("results")
            let thisParsedResultArray = [thisParsedResultGroup!] as NSArray
            let results = parsedResult.objectForKey("results") as! NSArray
            
            //var testStudents = Student.studentFromResults(results as! [[String : AnyObject]])
*/
            
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
        
        
        
        /*
        
        let parsedResult: AnyObject!
        do {
        
        let newData = data.subdataWithRange(NSMakeRange(5, (data.length) - 5))
        //print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        //print("parsedResult", parsedResult)
        
        
        
        
        
        let thisParsedResultGroup = parsedResult.objectForKey("results")
        //print("thisParsedResultGroup", thisParsedResultGroup)
        //print("thisParsedResultGroup count",thisParsedResultGroup?.count)
        //print("thisParsedResultGroup type",thisParsedResultGroup?.typeIdentifier)
        let thisParsedResultArray = [thisParsedResultGroup!] as NSArray
        //print("thisParsedResultArray", thisParsedResultArray)
        
        
        let results = parsedResult.objectForKey("results") as! NSArray
        //self.studentFromResults(results as! [[String : AnyObject]])
        
        self.testStudents = Student.studentFromResults(results as! [[String : AnyObject]])
        
        
        
        self.performUIUpdatesOnMain { () -> Void in
        self.tableView.reloadData()
        }
        
        
        }
        catch {
        
        print("Could not parse the data as JSON: '\(data)'")
        
        return
        }
        */
        
    }
    
    class  func sharedInstance() -> DBClient {
        struct Singleton {
            static var sharedInstance = DBClient()
        }
        return Singleton.sharedInstance
    }

}
