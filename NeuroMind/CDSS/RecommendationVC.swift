//
//  RecommendationViewController.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 29-10-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit
import MessageUI

class RecommendationVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var score = Score()
    var content = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        if content.characters.count > Helper.inputIncompleteLength {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("exportRecommendation"))
        }
        
        let formattedContent = "<html><body style='font-family: Arial'>\(content)</body></html>"
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
        createEmailMessageWithReport()
    }
    
    
    func createEmailMessageWithReport() {
        let email = MFMailComposeViewController()
        email.mailComposeDelegate = self
        email.setSubject("NeuroMind recommendation")
        
        let messageBodyText = "<p><em>Note: this email will be sent unencrypted and data privacy cannot be guaranteed, just as with any other email message. Be aware of privacy issues and do not provide patient identification details.</em></p>" +
            
            "If you think there is an error in this app, please send a message (or cc this email) to " +
            "<a href=\"mailto:support@digitalneurosurgeon.com\">support@digitalneurosurgeon.com</a>." +
            
            "<p>Optional comments:</p>" +
            
            "<h2>Recommendation</h2>" +
            "\(content)"
        
        email.setMessageBody(messageBodyText, isHTML: true)
        
        presentViewController(email, animated: true, completion: nil)
        
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
}
