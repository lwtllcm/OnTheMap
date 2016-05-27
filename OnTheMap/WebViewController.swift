//
//  WebViewController.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 4/20/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class WebViewController:UIViewController, UIWebViewDelegate {
        
    
    @IBOutlet weak var webView: UIWebView!
    
    var studentURL:String = ""
    
        override func viewDidLoad() {
            super.viewDidLoad()
            print("WebViewController viewDidLoad")

            webView.delegate = self

            
            let escapedStudentURL =  studentURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            print("escapedStudentURL ", escapedStudentURL)
            let url = NSURL(string: escapedStudentURL!)
            let request = NSURLRequest(URL: url!)
            print(request)
            webView.loadRequest(request)
            
            
        }
        
    func webViewDidStartLoad(webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("webViewDidFinishLoad")
    }
    
    private func escapedParameters(parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                let stringValue = "\(value)"
                
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "?\(keyValuePairs.joinWithSeparator("&"))"
        }
    }

        
}
