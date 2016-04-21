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
            //webView.loadHTMLString("www.google.com", baseURL: nil)
            webView.delegate = self
            //let url = NSURL(string: "http://www.google.com")
            
            let url = NSURL(string: studentURL)
            let request = NSURLRequest(URL: url!)
            print(request)
            webView.loadRequest(request)
            
            
            
            /*
            webView.loadRequest(NSURLRequest(URL: NSURL(string: "google.com")!))
            webView.reloadInputViews()
            
            //(NSURLRequest(URL: NSURL(string: "google.com")!))NSURL?
            //webView.delegate = self
            //reloadInputViews()
*/
            
        }
        
       /* override func viewWillAppear(animated: Bool) {
            super.viewDidLoad()
            print("WebViewController viewWillAppear")
            
        }
*/
    func webViewDidStartLoad(webView: UIWebView) {
        print("webViewDidStartLoad")
     //   activityIndicator.center = self.view.center
     //   activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("webViewDidFinishLoad")
      //  activityIndicator.stopAnimating()
      //  activityIndicator.hidden = true
    }
        
}
