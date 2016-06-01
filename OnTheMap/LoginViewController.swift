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
    
    var studentUserID = " "
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginSuccessIndicator = false
    
    var timer = NSTimer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController")
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loginSuccessIndicator = false
        print("LoginViewController viewWillAppear")
        counter = 0
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        print("loginPressed")
        
        
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            print("Username or Password Empty")
        }
        else {

            print("Username or Password not empty")

            
            let studentUserName = emailTextField.text!
            let studentPassword = passwordTextField.text!
            
            
            let jsonBody = "{\"udacity\": {\"username\": \"\(studentUserName)\", \"password\": \"\(studentPassword)\"}}"
            
            
            print("jsonBody", jsonBody)
         
            
            
            DBClient.sharedInstance().taskForUdacityPOSTMethod(jsonBody) { (results, error) in
                print("taskForUdacityPostMethod")
                
                
                if (error != nil) {
                    print("error from taskForUdacityPOSTMethod")
                    print(error!)
                    print(error!.localizedDescription)
                    
                    
                   // http://stackoverflow.com/questions/26947608/waituntilalltasksarefinished-error-swift
                    
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        
                        
                       let displayError =  error!.localizedDescription
                        let uiAlertController = UIAlertController(title: displayError, message: nil, preferredStyle: .Alert)

                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    uiAlertController.addAction(defaultAction)
                    self.presentViewController(uiAlertController, animated: true, completion: nil)
                    }
                    
                    
                
            }
            
                else {
                    let resultDictionary = results.valueForKey("account") as? NSDictionary
                    let userID = resultDictionary?.valueForKey("key")
                    print("key", userID)
                    
                    NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "Udacity.UserID")
                   let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(userID, forKey: "Udacity.UserID")
                    
                    
                    
                  
                    DBClient.sharedInstance().taskForGetUserID {(results, error) in
                        
                        if (error != nil) {

                            print("error after taskForGetUserID", error)
                          
                            let uiAlertController = UIAlertController(title: "Username/Password error", message: nil, preferredStyle: .Alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            uiAlertController.addAction(defaultAction)
                            self.presentViewController(uiAlertController, animated: true, completion: nil)
                            
                            
                            
                        }
                        else {
                        print("results after taskForGetUserID", results)
                         print(results.valueForKey("user")?.valueForKey("first_name"))
                            print(results.valueForKey("user")?.valueForKey("last_name"))

                            defaults.setObject(results.valueForKey("user")?.valueForKey("first_name"), forKey: "Udacity.FirstName")
                            defaults.setObject(results.valueForKey("user")?.valueForKey("last_name"), forKey: "Udacity.LastName")
                        self.loginSuccessIndicator = true
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.performSegueWithIdentifier("loginSuccess", sender: self)
                        }
                        }
                    }
               
            }
            
        }
        
    }
}
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        print("signUpButtonPressed")
        
        let url = NSURL(string: (("http://www.udacity.com")))!
        UIApplication.sharedApplication().openURL(url)
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
            print("shouldPerformSegueWithIdentifier")
            print("loginSuccessIndicator", loginSuccessIndicator)
            return loginSuccessIndicator
    }
 
    
    // http://stackoverflow.com/questions/12561735/what-are-unwind-segues-for-and-how-do-you-use-them
    
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue) {
        print("unwindToLogin in LoginViewController")
    }
    

}
