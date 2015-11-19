//
//  InfoTVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 17-11-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit
import MessageUI

class InfoTVC: UITableViewController, MFMailComposeViewControllerDelegate {

    enum SegueIdentifiers: String {
        case About = "About"
        case EULA = "EULA"
        case Quality = "Quality"
        case Privacy = "Privacy"
        case Twitter = "Twitter"
        case Blog = "Blog"
        case Developer = "Developer"
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.reuseIdentifier == "Email" {
            createEmailMessage()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController = segue.destinationViewController as! InfoDetailVC
        
        switch segue.identifier! {
        case SegueIdentifiers.About.rawValue:
            destinationController.title = "About NeuroMind"
            destinationController.content = "http://dign.eu/nm"
        case SegueIdentifiers.EULA.rawValue:
            destinationController.title = "License Agreement"
            destinationController.content = "http://dign.eu/eula"
        case SegueIdentifiers.Quality.rawValue:
            destinationController.title = "Quality Assurance"
            destinationController.content = "http://dign.eu/iris"
        case SegueIdentifiers.Privacy.rawValue:
            destinationController.title = "Privacy statement"
            destinationController.content = "http://dign.eu/eula/privacy"
        case SegueIdentifiers.Twitter.rawValue:
            destinationController.title = "@DigNeurosurgeon"
            destinationController.content = "http://twitter.com/digneurosurgeon"
        case SegueIdentifiers.Blog.rawValue:
            destinationController.title = "Blog"
            destinationController.content = "http://dign.eu/blg"
        case SegueIdentifiers.Developer.rawValue:
            destinationController.title = "About Pieter Kubben, MD, PhD"
            destinationController.content = "http://dign.eu/me"
        default:
            break
        }
    }
    
    
    // MARK:- Email
    
    
    func createEmailMessage() {
        let email = MFMailComposeViewController()
        email.mailComposeDelegate = self
        email.setToRecipients(["pieter@kubben.nl"])
        email.setSubject("NeuroMind feedback")
        email.setMessageBody("", isHTML: false)
        presentViewController(email, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
