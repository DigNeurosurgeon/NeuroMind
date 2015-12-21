//
//  RecommendationViewController.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 29-10-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit
//import MessageUI
import MobileCoreServices

class RecommendationVC: UIViewController { //, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var score = Score()
    var contentAsHTML = ""
    var contentAsCSV: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        if contentAsHTML.characters.count > Helper.inputIncompleteLength {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("exportRecommendation"))
        }
        
        let formattedContent =  "<html><head><style>" +
                "body {font-family: 'HelveticaNeue-Light', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, Arial, 'Lucida Grande', sans-serif;}" +
                "h3 {color: #107d76;}" +
                "h4 {color: #107d76;}" +
                ".info {font-weight: bold; color: DarkSlateGray;}" +
            "</style></head><body>" +
            "\(contentAsHTML)" +
            "</body></html>"
        webView.loadHTMLString(formattedContent, baseURL: nil)
        
    }
    
    
    @IBAction func showTextVersionForScore(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "ScoreDetail", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! ScoreDetailVC
        controller.score = score
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK:- Export recommendation
    
    
    func exportRecommendation() {
        //createEmailMessageWithReport() 
        
        if let content = contentAsCSV {
            /*
            let documentController = UIDocumentInteractionController(URL: content)
            documentController.presentOpenInMenuFromBarButtonItem(navigationItem.rightBarButtonItem!, animated: true)
            */
            
            let activityViewController = UIActivityViewController(activityItems: [content], applicationActivities: nil)
            if activityViewController.respondsToSelector("popoverPresentationController") {
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            }
            presentViewController(activityViewController, animated: true, completion: nil)
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "CSV file could not be created.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
}
