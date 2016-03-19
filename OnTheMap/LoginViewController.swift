//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/19/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        print("LoginViewController viewWillAppear")
        
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        print("loginPressed")
        
             
    }
}
