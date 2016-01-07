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
        case EULA = "EULA"
        case Quality = "Quality"
        case Privacy = "Privacy"
        case Twitter = "Twitter"
        case Blog = "Blog"
        case Developer = "Developer"
    }
    
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let id = cell?.reuseIdentifier {
            switch id {
            case "ReleaseNotes":
                let storyboard = UIStoryboard(name: "ReleaseNotes", bundle: nil)
                let controller = storyboard.instantiateInitialViewController() as! ReleaseNotesVC
                let navigationController = UINavigationController(rootViewController: controller)
                splitViewController?.showDetailViewController(navigationController, sender: nil)
            case "Email":
                createEmailMessage()
            default:
                break
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController = segue.destinationViewController as! InfoDetailVC
        
        switch segue.identifier! {
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
        email.setSubject("OrthoRef feedback")
        email.setMessageBody("", isHTML: false)
        presentViewController(email, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
