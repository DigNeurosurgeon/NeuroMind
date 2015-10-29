//
//  ScoresTableViewController.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 22-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class ScoresTVC: UITableViewController, UISearchResultsUpdating {
    
    var databasePath = NSString()
    var allScores = [Score]()
    var allSections = [String]()
    var scoresPerSection = [[Score]]()
    
    var filteredTableData = [Score]()
    var resultSearchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure tableview
        sortScoresPerSection()
        
        // Configure search controller
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = resultSearchController.searchBar

    }
    
    
    // MARK:- Data processing
    
    
    func sortScoresPerSection() {
        let dbManager = DatabaseManager()
        allScores = dbManager.loadScoresFromDatabase()
        var scoresForCurrentSection = [Score]()
        
        // Set first category
        allSections.append(allScores[0].category)
        
        // Process content
        for i in 1..<allScores.count {
            if allScores[i].category == allScores[i-1].category {
                scoresForCurrentSection.append(allScores[i])
            } else {
                allSections.append(allScores[i].category)
                scoresPerSection.append(scoresForCurrentSection)
                scoresForCurrentSection.removeAll()
                scoresForCurrentSection.append(allScores[i])
            }
        }
        
        // Set last category content
        scoresPerSection.append(scoresForCurrentSection)
    }
    
    
    func displayScoresInConsole() {
        // Used for debugging
        for index in allSections.indices {
            print("\n \(allSections[index].uppercaseString) \n")
            for score in scoresPerSection[index].indices {
                print(scoresPerSection[index][score].name)
            }
        }

    }
    
    
    func scoreForCellAtIndexPath(indexPath: NSIndexPath) -> Score {
        if resultSearchController.active {
            return filteredTableData[indexPath.row]
        } else {
            return scoresPerSection[indexPath.section][indexPath.row]
        }
    }
    
    
    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if resultSearchController.active {
            return 1;
        } else {
            return allSections.count
        }
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultSearchController.active {
            return nil
        } else {
            return allSections[section]
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.active {
            return filteredTableData.count
        } else {
            return scoresPerSection[section].count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell", forIndexPath: indexPath)
        let score = scoreForCellAtIndexPath(indexPath)
        
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = score.topic
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cdssItemPresent = true
        let score = scoreForCellAtIndexPath(indexPath)
        resultSearchController.active = false
        
        if cdssItemPresent {
            let storyboard = UIStoryboard(name: "SpetzlerPonce", bundle: nil)
            let controller = storyboard.instantiateInitialViewController() as! SpetzlerPonceTVC
            controller.title = "Spetzler Ponce"
            navigationController?.pushViewController(controller, animated: true)
            
        } else {
            let storyboard = UIStoryboard(name: "ScoreDetail", bundle: nil)
            let controller = storyboard.instantiateInitialViewController() as! ScoreDetailVC
            controller.score = score
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    // MARK:- UISearchResultsUpdating protocol
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredTableData.removeAll(keepCapacity: false)
        let searchText = searchController.searchBar.text
        filteredTableData = allScores.filter{$0.name.localizedCaseInsensitiveContainsString(searchText!) || $0.topic.localizedCaseInsensitiveContainsString(searchText!)}
        tableView.reloadData()
    }
    
    
}
