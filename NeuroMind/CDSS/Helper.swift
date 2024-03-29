//
//  UtilityTVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 29-10-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class Helper: UITableViewController {
    
    static let lesserThanOrEqualTo = "\u{2264}"
    static let greaterThanOrEqualTo = "\u{2265}"
    static let inputIncomplete = "Not all parameters have been entered."
    static var inputIncompleteLength: Int {
        get {
            return inputIncomplete.characters.count
        }
    }
    
    
    // MARK:- Functions    

    static func updateSelectionAtIndexPath(indexPath: NSIndexPath, forTableView tableView: UITableView) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let section = indexPath.section
        
        for rowNumber in 0..<tableView.numberOfRowsInSection(section) {
            let tempPath = NSIndexPath(forRow: rowNumber, inSection: section)
            let tempCell = tableView.cellForRowAtIndexPath(tempPath)
            tempCell?.accessoryType = .None
        }
        
        cell?.accessoryType = .Checkmark
        
        /*
        // More elegant code with selectedCellIndices
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedRowInSection = cdss.selectedCellIndices[indexPath.section]
        for row in 0..<tableView.numberOfRowsInSection(indexPath.section) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: indexPath.section))
        cell!.accessoryType = row == selectedRowInSection ? .Checkmark : .None
        }
        */
        
    }
    
    
    /*
    static func getTVCForDecisionSupportFromScore<T>(score: Score, withTypeAlias: T.Type) -> T {
        let storyboard = UIStoryboard(name: score.storyboardName, bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! T
        //controller.title = score.name
        return controller
    }
    */
    
    
    static func getRecommendationVCWithContent(content: String, forScore score: Score) -> RecommendationVC {
        let kRecommendationString = "Recommendation"
        let storyboard = UIStoryboard(name: kRecommendationString, bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! RecommendationVC
        controller.title = kRecommendationString
        controller.score = score
        controller.contentAsHTML = content
        
        return controller
    }
    

    static func createFileWithDateAndParametersAsCSVForItem(item: String, withHeader header: String, andContent content: String) -> NSURL {
        // Create date string from local timezone
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone()
        
        // Format for database
        dateFormatter.dateFormat = "YYYY-MM-dd hh:mm"
        let localDate = dateFormatter.stringFromDate(date)
        let csvHeader = "date_time,\(header)"
        let csvContent = "\(localDate),\(content)"
        let csvString = "\(csvHeader)\n\(csvContent)"
        
        // Format for filename
        dateFormatter.dateFormat = "YYYY_MM_dd_hhmm"
        let localDateForFileName = dateFormatter.stringFromDate(date)
        
        // Create CSV file
        let dirPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docsDir = dirPaths[0]
        let csvFileName = "\(item)_\(localDateForFileName).csv"
        let csvFilePath = docsDir.stringByAppendingString("/" + csvFileName)
        
        // Generate output
        var csvURL: NSURL?
        do {
            try csvString.writeToFile(csvFilePath, atomically: true, encoding: NSUTF8StringEncoding)
            csvURL = NSURL(fileURLWithPath: csvFilePath)
        } catch {
            csvURL = nil
        }
        
        return csvURL!
    }
    

}
