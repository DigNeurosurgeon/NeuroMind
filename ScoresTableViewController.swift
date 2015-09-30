//
//  ScoresTableViewController.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 22-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class ScoresTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var databasePath = NSString()
    var allScores = [Score]()
    var allSections = [String]()
    var scoresPerSection = [[Score]]()
    
    var filteredTableData = [Score]()
    var resultSearchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.hidesNavigationBarDuringPresentation = false
        
        tableView.tableHeaderView = resultSearchController.searchBar
        //tableView.reloadData()

        // Do the job...
        prepareDatabase()
        loadScoresFromDatabase()
        sortScoresPerSection()

    }
    
    
    // MARK:- Data processing
    
    
    func prepareDatabase() {
        //let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as NSString
        
        databasePath = docsDir.stringByAppendingPathComponent("scores.db")
        
//        if !filemgr.fileExistsAtPath(databasePath as String) {
//            
//            let contactDB = FMDatabase(path: databasePath as String)
//            
//            if contactDB == nil {
//                println("Error: \(contactDB.lastErrorMessage())")
//            }
//            
//            if contactDB.open() {
//                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
//                if !contactDB.executeStatements(sql_stmt) {
//                    println("Error: \(contactDB.lastErrorMessage())")
//                }
//                contactDB.close()
//            } else {
//                println("Error: \(contactDB.lastErrorMessage())")
//            }
//        }
    }

    
    func loadScoresFromDatabase() {
        let scoresDB = FMDatabase(path: databasePath as String)
        
        if scoresDB.open() {
            let sqlString = "SELECT * FROM scores WHERE neuro = 1 ORDER BY category, name ASC"
            let results: FMResultSet = scoresDB.executeQuery(sqlString, withArgumentsInArray: nil)
            
            while results.next() {
                let score = Score(
                        name: results.stringForColumn("name"),
                        topic: results.stringForColumn("topic"),
                        content: results.stringForColumn("content"),
                        category: results.stringForColumn("category"),
                        reference: results.stringForColumn("reference")
                )
                allScores.append(score)
            }
            scoresDB.close()
        } else {
            print("Error opening scores database.")
        }
    }
    
    
    func sortScoresPerSection() {
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
        for index in allSections.indices {
            print("\n \(allSections[index].uppercaseString) \n")
            for score in scoresPerSection[index].indices {
                print(scoresPerSection[index][score].name)
            }
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
        var currentScore: Score
        
        if resultSearchController.active {
            currentScore = filteredTableData[indexPath.row]
        } else {
            currentScore = scoresPerSection[indexPath.section][indexPath.row]
        }
        
        cell.textLabel?.text = currentScore.name
        cell.detailTextLabel?.text = currentScore.topic
        
        return cell
    }
    
    
    // MARK:- UISearchResultsUpdating protocol
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredTableData.removeAll(keepCapacity: false)
        let searchText = searchController.searchBar.text
        filteredTableData = allScores.filter{$0.name.localizedCaseInsensitiveContainsString(searchText!) || $0.topic.localizedCaseInsensitiveContainsString(searchText!)}
        tableView.reloadData()
    }

    
    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Details" {
            // Get the new view controller using segue.destinationViewController.
            let detailViewController = segue.destinationViewController as! ScoresDetailViewController
            
            // Pass the selected object to the new view controller.
            let indexPath = tableView.indexPathForSelectedRow
            var selectedScore = Score()
            if resultSearchController.active {
                selectedScore = filteredTableData[indexPath!.row]
                resultSearchController.active = false
            } else {
                selectedScore = scoresPerSection[indexPath!.section][indexPath!.row]
            }
            detailViewController.score = selectedScore
        }
    }
    

}
