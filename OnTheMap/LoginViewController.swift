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
        getRequestToken()
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            print("Username or Password Empty")
        }
        else {
            print("Username or Password not empty")
            
            print(emailTextField.text)
            print(passwordTextField.text)

            
            
        }
        
             
    }
    
    private func getRequestToken() {
        // set parameters
       // let methodParameters = [UdacityConstants.UdacityParameterKeys.ApiKey: UdacityConstants.UdacityParameterValues.ApiKey]
        
        //build url, configure request
       // let request = NSURLRequest(URL: AppDelegate.tmdbURLFromParameters(methodParameters, withPathExtension: "/authentication/token/new"))
        /*
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"username\", \"password\": \"********\"}".dataUsingEncoding(NSUTF8StringEncoding)
        */
        
        let methodParameters = UdacityParameterKeys.Parameter
        let request = NSURLRequest(URL: udacityURLFromParameters(methodParameters,withPathExtension: nil))
        
        print(request)
        
        
      /*
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = "udacity.com"
        components.path = "/api/session"
        
        components.queryItems =[NSURLQueryItem]()
        for (key,value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
            UdacityParameterKeys.udacity
      */
        
        //components.user = "***"
        //components.password = "!!!"

        //let componentsRequest = NSMutableURLRequest(URL: components.URL!)
        //print(componentsRequest)
        
    
        
        //print(components.URL!)
        
        
       // let url = NSURL(string: "https://www.udacity.com/api/session?method%20POST&user%20***&password&20!!!")!
        
        
        //make request
       // let task = appDelegate.sharedSession.dataTaskWithRequest(request) { (data, response, error) in
        /*
        func displayError(error: String) {
            print(error)
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                self.debugTextLabel.text = "Login Failed (Request Token)."
            }
        }
        
        guard (error == nil) else {
            displayError("There was an error with your request: \(error)")
            return

        }
        
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where
            statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
        }
        
        guard let date = data else {
                displayError("No data was returned by the request!")
                return
        }
       
*/
       // }
        
        //parse data
        /*
        let parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            displayError("Could not parse the data as JSON: '\(data)'")
            return
        }
        
        guard let requestToken = parsedResult[Constants.TMDBResponseKeys.RequestToken] as? String else {
            displayError("Cannot find key '\(Constants.TMDBResponseKeys.RequestToken)' in \(parsedResult)")
            return
        }
        */
        //use data
        //print(requestToken)
        
        //start request
        //task.resume()
       // task.resume()
    }
    
    private func loginWithToken(requestToken:String) {
        
    }
    
     func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
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

}
