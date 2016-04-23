//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/19/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var appDelegate: AppDelegate!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController")
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        print("LoginViewController viewWillAppear")        
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        print("loginPressed")
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            print("Username or Password Empty")
        }
        else {

            print("Username or Password not empty")
 
            getRequestToken()
            //getUserID()

            
        }
        
             
    }
    
    private func getRequestToken() {
        print("getRequestToken")
        
        
        // **** 1) set parameters - create dictionary with name/value pairs for parameters needed in final URL
        

        let methodParameters : [String:AnyObject] =  [
            
            UdacityParameterKeys.Username:emailTextField.text!,
            UdacityParameterKeys.Password:passwordTextField.text!
        ]
        
            print("methodParameters", methodParameters)
        
        //  ****** 2) build url - use app delegate's ...URLFromParameters, ***** 3) configure request
        
        
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(methodParameters,withPathExtension: nil))

        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBodyString = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}"
         print("request httpbody: \(httpBodyString)")
        
        request.HTTPBody = httpBodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
                print("request",request)

        
        //   ***** 4) make request
        
        
        let task = appDelegate.sharedSession.dataTaskWithRequest(request) { (data, response, error) in
            
            print("error" , error)
            //print("data", data)
            //print("response", response)
            
            
        //  ****** 5) parse data
            
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
            
            //  ****** 6) use data

        }
        
       
        
        //  ****** 7) start request
        
        
        task.resume()
    }
 
    
    
    
    private func loginWithToken(requestToken:String) {
        
    }

    
    
    
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
        
        /*
        // **** 1) set parameters - create dictionary with name/value pairs for parameters needed in final URL
        
        
        let methodParameters : [String:AnyObject] =  [
            
            UdacityParameterKeys.Username:emailTextField.text!,
            UdacityParameterKeys.Password:passwordTextField.text!
        ]
        
        print("methodParameters", methodParameters)
        
        //  ****** 2) build url - use app delegate's ...URLFromParameters, ***** 3) configure request
        
        
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(methodParameters,withPathExtension: nil))
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBodyString = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}"
        print("request httpbody: \(httpBodyString)")
        */
        let requestUserID = NSMutableURLRequest(URL:NSURL(string:"https://www.udacity.com/api/users/me")!)
        
        //request.HTTPBody = httpBodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        //print("request",request)
        
        
        //   ***** 4) make request
        
        
        let task = appDelegate.sharedSession.dataTaskWithRequest(requestUserID) { (data, response, error) in
            
            print("error" , error)
            print("data", data)
            print("response", response)
            
            print("response for getUserID", response)
            
            //  ****** 5) parse data
            
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
                
                return
            }
            
            //  ****** 6) use data
            
        }
        
        
        
        //  ****** 7) start request
        
        
        task.resume()
    }
    


}
