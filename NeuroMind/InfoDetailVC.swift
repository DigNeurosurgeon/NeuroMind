//
//  InfoVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 17-11-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit
import MobileCoreServices

class InfoDetailVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoWebView: UIWebView!
    var loadRemoteContent = false // default setting based on majority of menu items
    var content = ""
    var remoteURL = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoWebView.delegate = self
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true

        if loadRemoteContent {
            // Load website
            remoteURL = NSURL(string: content)!
            let request = NSURLRequest(URL: remoteURL)
            infoWebView.loadRequest(request)
            
        } else {
            loadLocalWebContent(content)
            
            /*
            // Show local info
            let infoContent =  "<html><body style=\"font-family: Arial;\">" +
                "<p>\(content)</p>" +
            "</body></html>"
            infoWebView.loadHTMLString(infoContent, baseURL: nil)
            */
        }
    }
    
    
    private func loadLocalWebContent(fileName: String) {
        let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: "html")
        let request = NSURLRequest(URL: url!)
        infoWebView.loadRequest(request)
    }
    
    
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }

    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    
    @IBAction func actionButtonTapped(sender: AnyObject) {
        let activityViewController = UIActivityViewController(activityItems: [remoteURL], applicationActivities: nil)
        if activityViewController.respondsToSelector("popoverPresentationController") {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    

}
