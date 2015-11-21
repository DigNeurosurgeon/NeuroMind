//
//  IRIS.swift
//  Interactive Risk Inventory System
//  Unique identifier: eu.dign.iRIS
//
//  Created by Pieter Kubben on 25-04-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation
import UIKit

class IRIS {
    
    
    //MARK: - Instance variables for class
    
    
    let version: String
    let statusURL: NSURL
    let expirationTimeInDays: Int
    let eulaURL: NSURL
    
    enum DefaultStatusButtonText: String {
        case OK = "OK"
        case Understood = "Understood"
        case Ignore = "Ignore"
    }
    
    
    // MARK: - Text values
    // Can be localized and customized
    
    
    private let txtOK = "OK"
    private let txtUpdateRequired = "Safety check required"
    private let txtUpdateNow = "Check now!"
    private let txtLastSavedDateUnknown = "Last safety check unknown."
    private let txtCheckForUpdatesOnline = "You have used this app offline for a while. Please perform a safety check online to see if all content is up to date."
    private let txtStatusErrorText = "HTTP status code has unexpected value."
    private let txtEulaWelcome = "Welcome"
    private let txtEulaRead = "Read EULA"
    private let txtEulaMessage = "By using this app you agree to the End User License Agreement (EULA)."
    
    private let txtStatusIndicatorOK = "OK"
    private let txtStatusIndicatorUnknown = "??"
    private let txtStatusIndicatorIssue = "!!"
    
    
    // MARK: - Constants
    // Break glass to crash the app...
    

    private let kStatusVersion = "version"
    private let kStatusMessage = "message"
    private let kStatusIssue = "issue"
    private let kStatusVersionKeyName = "statusVersion"
    private let kStatusDescriptionKeyName = "statusDescription"
    private let kStatusDateKeyName = "statusDate"
    private let kStatusDateFormat = "YYYY-MM-dd"
    private let kStatusDateDisplayFormat = "MMM dd, YYYY"
    private let kStatusErrorDomain = "eu.dign"
    private let kEulaAcceptedKeyName = "eulaWasAccepted"
    private let kEulaAcceptedKeyValue = "true"
    
    
    // MARK: - Initializer
    
    
    init(version: String, statusURLString: String, expirationTimeInDays: Int, eulaURLString: String) {
        
        self.version = version ?? ""
        self.statusURL = NSURL(string: statusURLString)!
        self.expirationTimeInDays = expirationTimeInDays ?? 1
        self.eulaURL = NSURL(string: eulaURLString)!
        
        self.checkIfUserAcceptedEULA()
        configureStatusMessage()
    }
    
    
    // MARK: - Local status
    
    
    private func configureStatusMessage() {
        let preferences = NSUserDefaults.standardUserDefaults()
        let currentVersionForComparison = version
        //var statusUpdates = [Status]()
        var statusForCurrentVersion: Status!
        //var statusMessage = String()
        
        // Check for update before setting the text
        if localStatusNeedsUpdate() {
            statusAlert(txtUpdateRequired, messageText: txtCheckForUpdatesOnline, defaultButton: .Ignore, showUpdateButton: true)
        }
        
        if let issue = preferences.stringForKey("statusHasIssue") {
            if issue == "yes" {
                issueAlert(getLocalStatusMessage())
            }
        }
        
        
        // Try to update status anyway...
        getStatusFromRemoteSource { (statusUpdates) -> Void in
            
            for status in statusUpdates {
                if status.version == currentVersionForComparison {
                    statusForCurrentVersion = status
                }
            }
            
            self.saveStatusFromRemoteSource(statusForCurrentVersion)
            
            // Set status indicator text
            let indicatorText: String
            
            if statusForCurrentVersion.hasIssue {
                indicatorText = self.txtStatusIndicatorIssue
                self.issueAlert(statusForCurrentVersion.description)
            } else {
                indicatorText = self.txtStatusIndicatorOK
            }
            
            preferences.setValue(indicatorText, forKey: "statusBarButtonTitle")
        }
        
    }

    
    private func getLocalStatusMessage() -> String {
        let preferences = NSUserDefaults.standardUserDefaults()
        if let statusMessage = preferences.stringForKey(kStatusDescriptionKeyName) {
            return statusMessage
        } else {
            return txtStatusIndicatorUnknown
        }
    }
    
    
    private func saveStatusFromRemoteSource(status: Status) {
        let preferences = NSUserDefaults.standardUserDefaults()
        let currentDateAsString = getCurrentDateAsString()
        var hasIssue = "no"
        
        preferences.setValue(status.version, forKey: kStatusVersionKeyName)
        preferences.setValue(status.description, forKey: kStatusDescriptionKeyName)
        preferences.setValue(currentDateAsString, forKey: kStatusDateKeyName)
        preferences.setValue(expirationTimeInDays, forKey: "statusExpirationTime")
        if status.hasIssue {
            hasIssue = "yes"
        }
        preferences.setValue(hasIssue, forKey: "statusHasIssue")
    }
    
    
    private func localStatusNeedsUpdate() -> Bool {
        let preferences = NSUserDefaults.standardUserDefaults()
        let localStatusMessage: String
        var needsUpdate = true
        let _ = "2015-01-01"
        
        if let lastSavedDateString = preferences.stringForKey(kStatusDateKeyName) {
            if daysBetweenNowAndLastSavedDate(lastSavedDateString) < expirationTimeInDays {
                localStatusMessage = txtStatusIndicatorOK
                needsUpdate = false
            } else {
                localStatusMessage = txtStatusIndicatorUnknown
                let localStatusDescription = "Last update &gt;" + String(self.expirationTimeInDays) + " days ago."
                preferences.setValue(localStatusDescription, forKey: kStatusDescriptionKeyName)
            }
            preferences.setValue(localStatusMessage, forKey: kStatusMessage)
        }
        
        return needsUpdate
    }
    
    
    private func statusAlert(titleText: String, messageText: String, defaultButton: DefaultStatusButtonText, showUpdateButton: Bool) {
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: defaultButton.rawValue, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        if showUpdateButton {
            let updateAction = UIAlertAction(title: txtUpdateNow, style: .Default, handler: { (update) in
                self.configureStatusMessage()
            })
            alertController.addAction(updateAction)
        }
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    private func issueAlert(description: String) {
        let issueText = "There is an issue with the current version of this app. \n\nDescription: \n\(description)"
        statusAlert("Warning", messageText: issueText, defaultButton: .OK, showUpdateButton: false)
    }
    
    
    // MARK: - Remote status
    
    
    private func getStatusDataWithSuccess(success: ((statusData: NSData!) -> Void)) {
        
        loadDataFromURL(statusURL, completion:{(data, error) -> Void in
            if let urlData = data {
                success(statusData: urlData)
            }
        })
    }
    
    
    private func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:self.kStatusErrorDomain, code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : self.txtStatusErrorText])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
    
    
    typealias RemoteStatusHandler = (statusUpdates :[Status]) -> Void
    
    private func getStatusFromRemoteSource(handler:RemoteStatusHandler) {
        
        var allStatusUpdates = [Status]()
        
        getStatusDataWithSuccess { (statusData) -> Void in
            let json = JSON(data: statusData)
            
            if let jsonArray = json.array {
                
                for jsonItem in jsonArray {
                    let statusVersion: String? = jsonItem[self.kStatusVersion].string
                    let statusMessage: String? = jsonItem[self.kStatusMessage].string
                    let statusIssueValue: Int? = Int(jsonItem[self.kStatusIssue].string!)
                    
                    let update = Status(version: statusVersion, description: statusMessage, issueValue: statusIssueValue)
                    allStatusUpdates.append(update)
                }
            }
            
            handler(statusUpdates: allStatusUpdates)
        }
    }
    

    // MARK: - Date & time
    
    
    private func daysBetweenNowAndLastSavedDate(lastSavedDateString: String) -> Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = kStatusDateFormat
        let lastSavedDate = dateFormatter.dateFromString(lastSavedDateString)
        
        let now = NSDate()
        let timeIntervalInSeconds = lastSavedDate!.timeIntervalSinceDate(now)
        let secondsInDay = 3600 * 24.0
        let days = ceil(timeIntervalInSeconds / secondsInDay)
        return Int(abs(days))
    }
    
    
    private func getCurrentDateAsString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = kStatusDateFormat
        return dateFormatter.stringFromDate(NSDate())
    }

    
    // MARK: - Legal stuff
    
    func checkIfUserAcceptedEULA() {
        if !licenseAgreementWasAcccepted() {
            eulaAlert()
        }
    }
    
    private func eulaAlert() {
        let alertController = UIAlertController(title: txtEulaWelcome, message: txtEulaMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: txtOK, style: .Default, handler: { (ok) in
            let preferences = NSUserDefaults.standardUserDefaults()
            preferences.setValue(self.kEulaAcceptedKeyValue, forKey: self.kEulaAcceptedKeyName)
        })
        let eulaAction = UIAlertAction(title: self.txtEulaRead, style: .Default, handler: { (readEULA) in
            UIApplication.sharedApplication().openURL(self.eulaURL)
        })
        alertController.addAction(defaultAction)
        alertController.addAction(eulaAction)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    private func licenseAgreementWasAcccepted() -> Bool {
        let preferences = NSUserDefaults.standardUserDefaults()
        if preferences.stringForKey(kEulaAcceptedKeyName) == nil {
            return false
        } else {
            return true
        }
    }
    
    
    class func loadStatusContentInWebView(webView: UIWebView) {
        let preferences = NSUserDefaults.standardUserDefaults()
        let dateFormatter = NSDateFormatter()
        var currentVersion = ""
        var descriptionForCurrentVersion = ""
        var expirationTime = "..."
        let dateOfLastUpdate: String
        
        if let version = preferences.stringForKey("statusVersion") {
            currentVersion = version
        }
        
        // Generate display for message
        if let description = preferences.stringForKey("statusDescription") {
            descriptionForCurrentVersion = description
        }
        
        if let time = preferences.stringForKey("statusExpirationTime") {
            expirationTime = time
        }
        
        // Generate display for last saved date
        if let lastSavedDateString = preferences.stringForKey("statusDate") {
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let lastSavedDate = dateFormatter.dateFromString(lastSavedDateString)
            
            dateFormatter.dateFormat = "MMM dd, YYYY"
            dateOfLastUpdate = dateFormatter.stringFromDate(lastSavedDate!)
        } else {
            dateOfLastUpdate = "Unknown"
        }
        
        
        let statusHTMLString = "<body style=\"font-family: Arial; \"> " +
            
            "<h3>Legend</h3>" +
            "<table cellpadding=\"10\">" +
            "<tr><td><strong>Status</strong></td> <td><strong>Description</strong></td></tr>" +
            "<tr><td valign=\"top\">OK</td> <td>Software is up-to-date <br/>(updated &lt;" + expirationTime + " days ago)</td></tr>" +
            "<tr><td valign=\"top\">!!</td> <td>Known issue with current version</td></tr>" +
            "<tr><td valign=\"top\">??</td> <td>Date of last update unknown</td></tr>" +
            "</table>" +
            
            "<h3>Version " + currentVersion + "</h3>" +
            "<p>" + descriptionForCurrentVersion + "</p>" +
            
            "<h3>Last update</h3>" +
            "<p>" + dateOfLastUpdate + "</p>" +
            
        "</body>"
        
        webView.loadHTMLString(statusHTMLString, baseURL: nil)
    }
    
}