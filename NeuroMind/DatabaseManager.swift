//
//  DatabaseManager.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 29-10-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class DatabaseManager {
    
    private let dbFileName = "scores.db"
    private var database:FMDatabase!
    
    
    init() {
        openLocalDatabase()
    }
    
    
    func openLocalDatabase() {
        let resourcePath = NSBundle.mainBundle().resourceURL!.absoluteString
        let dbPath = resourcePath.stringByAppendingString(dbFileName)
        let database = FMDatabase(path: dbPath)
        
        /* Open database read-only. */
        if (!database.openWithFlags(1)) {
            print("Could not open database at \(dbPath).")
        } else {
            self.database = database;
        }
    }
    
    
    func openRemoteDatabase() {
        let urlString = NSURL(string: "http://neurodss.com/scores.db")
        let session = NSURLSession.sharedSession()
        
        let task: NSURLSessionDownloadTask = session.downloadTaskWithURL(urlString!, completionHandler: {(data, response, error) in
            // code to process results comes here
        })
        
        task.resume()
    }
    
    
    func loadScoresFromDatabase() -> [Score] {
        
        var scores = [Score]()
        let sqlString = "SELECT * FROM scores WHERE neuro = 1 ORDER BY category, name ASC"
        
        if let scoresDB = database, results = scoresDB.executeQuery(sqlString, withArgumentsInArray: nil) {
            while results.next() {
                
                let score = Score(
                    id: Int(results.intForColumn("id")),
                    name: results.stringForColumn("name"),
                    topic: results.stringForColumn("topic"),
                    content: results.stringForColumn("content"),
                    category: results.stringForColumn("category"),
                    reference: results.stringForColumn("reference"),
                    cdss: Int(results.intForColumn("cdss"))
                )
                
                if let storyboard = results.stringForColumn("storyboard") {
                    score.storyboardName = storyboard
                }
                
                scores.append(score)
            }
            scoresDB.close()
        } else {
            print("Error opening scores database.")
        }
        
        return scores
    }
    
    
    func closeDatabase() {
        if (database != nil) {
            database.close()
        }
    }
    
}