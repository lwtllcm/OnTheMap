//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/19/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var studentUserID = " "
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginSuccessIndicator = false
    
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController")
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginSuccessIndicator = false
        print("LoginViewController viewWillAppear")
        
        subscribeToKeyboardNotifications()
        subscribeToKeyboardWillHideNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            print("Username or Password Empty")
            
            OperationQueue.main.addOperation {
                
                let uiAlertController = UIAlertController(title: "Username or Password Missing", message: nil, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.present(uiAlertController, animated: true, completion: nil)
            }
            
        }
        else {

            print("Username or Password not empty")

            
            let studentUserName = emailTextField.text!
            let studentPassword = passwordTextField.text!
            
            
            let jsonBody = "{\"udacity\": {\"username\": \"\(studentUserName)\", \"password\": \"\(studentPassword)\"}}"
 
            
            DBClient.sharedInstance().taskForUdacityPOSTMethod(jsonBody) { (results, error) in
                print("taskForUdacityPostMethod")
                
                
                if (error != nil) {
                    print("error from taskForUdacityPOSTMethod")
                    print(error!)
                    print(error!.localizedDescription)
                    
                    
                   // http://stackoverflow.com/questions/26947608/waituntilalltasksarefinished-error-swift
                    
                    
                    OperationQueue.main.addOperation {
                        
                        
                        print(error?.localizedDescription as Any)
                        let errorMsg  = error?.localizedDescription
                        let uiAlertController = UIAlertController(title: errorMsg, message: nil, preferredStyle: .alert)

                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    uiAlertController.addAction(defaultAction)
                    self.present(uiAlertController, animated: true, completion: nil)
                    }
                    
                    
                
            }
            
                else {
                    let resultDictionary = results?.value(forKey: "account") as? NSDictionary
                    let userID = resultDictionary?.value(forKey: "key")
                    print("key", userID as Any)
                    
                    UserDefaults.standard.set(userID, forKey: "Udacity.UserID")
                   let defaults = UserDefaults.standard
                    defaults.set(userID, forKey: "Udacity.UserID")
                    
                    if (defaults.string(forKey: "Udacity.UserID") == nil) {
                    print("no UserID")
                        
                        OperationQueue.main.addOperation {
                            
                            
                            //print(error?.localizedDescription)
                            print(error?.localizedDescription as Any)
                            let errorMsg  = error?.localizedDescription
                            let uiAlertController = UIAlertController(title: errorMsg, message: "The email or password you entered is invalid", preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            uiAlertController.addAction(defaultAction)
                            self.present(uiAlertController, animated: true, completion: nil)
                        }
                    }
                    else {
                        DBClient.sharedInstance().taskForGetUserID(userID as! String) {(results, error) in
                            
                            if (error != nil) {
                                
                                print("error after taskForGetUserID", error as Any)
                                
                                print(error?.localizedDescription as Any)
                                let errorMsg  = error?.localizedDescription
                                
                                
                                
                                let uiAlertController = UIAlertController(title: errorMsg, message: nil, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                uiAlertController.addAction(defaultAction)
                                self.present(uiAlertController, animated: true, completion: nil)
                                
                                
                                
                            }
                            else {
                                //print("results after taskForGetUserID", results)
                                print("Udacity.first_name",(results?.value(forKey: "user") as AnyObject).value(forKey: "first_name"))
                                print("Udacity.last_name",(results?.value(forKey: "user") as AnyObject).value(forKey: "last_name"))
                                
                                defaults.set((results?.value(forKey: "user") as AnyObject).value(forKey: "first_name"), forKey: "Udacity.FirstName")
                                defaults.set((results?.value(forKey: "user") as AnyObject).value(forKey: "last_name"), forKey: "Udacity.LastName")
                                self.loginSuccessIndicator = true
                                
                                OperationQueue.main.addOperation {
                                    self.emailTextField.text = nil
                                    self.passwordTextField.text = nil
                                    self.performSegue(withIdentifier: "loginSuccess", sender: self)
                                }
                            }
                        }
                    }
                    
                    /*
                    DBClient.sharedInstance().taskForGetUserID(userID as! String) {(results, error) in
                        
                        if (error != nil) {

                            print("error after taskForGetUserID", error)
                            
                            print(error?.localizedDescription)
                            let errorMsg  = error?.localizedDescription

                            
                          
                            let uiAlertController = UIAlertController(title: errorMsg, message: nil, preferredStyle: .Alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            uiAlertController.addAction(defaultAction)
                            self.presentViewController(uiAlertController, animated: true, completion: nil)
                            
                            
                            
                        }
                        else {
                        //print("results after taskForGetUserID", results)
                         print(results.valueForKey("user")?.valueForKey("first_name"))
                            print(results.valueForKey("user")?.valueForKey("last_name"))

                            defaults.setObject(results.valueForKey("user")?.valueForKey("first_name"), forKey: "Udacity.FirstName")
                            defaults.setObject(results.valueForKey("user")?.valueForKey("last_name"), forKey: "Udacity.LastName")
                        self.loginSuccessIndicator = true
                           
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.emailTextField.text = nil
                            self.passwordTextField.text = nil
                        self.performSegueWithIdentifier("loginSuccess", sender: self)
                        }
                        }
                    }
               */
            }
            
        }
        
    }
}
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        print("signUpButtonPressed")
        
        let url = URL(string: (("http://www.udacity.com")))!
        UIApplication.shared.openURL(url)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
            print("shouldPerformSegueWithIdentifier")
            print("loginSuccessIndicator", loginSuccessIndicator)
            return loginSuccessIndicator
    }
 
    
    // http://stackoverflow.com/questions/12561735/what-are-unwind-segues-for-and-how-do-you-use-them
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        print("unwindToLogin in LoginViewController")
    }
   
    
    func keyboardWillShow(_ notification: Notification) {
        if (emailTextField.isFirstResponder) {
            print("studentLocationText is FirstResponder")
            //  view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
        //else
        
        if (passwordTextField.isFirstResponder) {
            print("studentLinkText is FirstResponder")
            
            view.frame.origin.y = getKeyboardHeight(notification) * -0.1
        }
        
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if emailTextField.isFirstResponder {
            view.frame.origin.y = 0.0
        }
            
        else
            if passwordTextField.isFirstResponder {
                view.frame.origin.y = 0.0
        }
        
    }
    func textFieldDidBeginEditing( _ textField: UITextField) {
        print("textFieldDidBeginEditing")
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        print("getKeyboardHeight")
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        print("subscribeToKeyboardNotifications")
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications() {
        print("subscribeToKeyboardNotifications")
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        print("unsubscribeFromKeyboardNotifications")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardWillHideNotifications() {
        print("unsubscribeFromKeyboardNotifications")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    

}
