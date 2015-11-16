//
//  UtilityTVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 29-10-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class Helper: UITableViewController {
    
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
        
    }
    
    
    static func getTVCForDecisionSupportFromScore<T: UITableViewController>(score: Score) -> T {
        let storyboard = UIStoryboard(name: score.storyboardName, bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! T
        controller.title = score.name

        return controller
    }
    
    
    static func getRecommendationVCWithContent(content: String) -> RecommendationVC {
        let recommendationString = "Recommendation"
        let storyboard = UIStoryboard(name: recommendationString, bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! RecommendationVC
        controller.title = recommendationString
        controller.content = content
        
        return controller
    }
    

    

}
