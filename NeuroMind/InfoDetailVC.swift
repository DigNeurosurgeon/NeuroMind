//
//  InfoVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 17-11-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class InfoDetailVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoWebView: UIWebView!
    var loadRemoteContent = true // default setting based on majority of menu items
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true

        if loadRemoteContent {
            // Load website
            let url = NSURL(string: content)
            let request = NSURLRequest(URL: url!)
            
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            infoWebView.loadRequest(request)
            activityIndicator.stopAnimating()
            
        } else {
            // Show local info
            let infoContent =  "<html><body style=\"font-family: Arial;\">" +
                "<p>\(content)</p>" +
            "</body></html>"
            infoWebView.loadHTMLString(infoContent, baseURL: nil)
        }
    }


}
