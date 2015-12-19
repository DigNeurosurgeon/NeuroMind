//
//  ScoresTableViewController.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 22-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

protocol ContainsScore: class {
    var score: Score {get set}
//    var productID: String? {get set}
}

class ScoresTVC: UITableViewController, UISearchResultsUpdating, UIPopoverPresentationControllerDelegate {
    
    var detailViewController: ScoreDetailVC? = nil
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    var showFavorites = false
    var databasePath = NSString()
    var allScores = [Score]()
    var allSections = [String]()
    var scoresPerSection = [[Score]]()
    var iris: IRIS!
    // var keystore = NSUbiquitousKeyValueStore()
    
    var filteredTableData = [Score]()
    var resultSearchController = UISearchController(searchResultsController: nil)

    
    // MARK:- View Managers
    
    
    override func viewDidLoad() {
        let currentNeuroMindVersion = "3.0"
        
        // Show release notes at first load of current version
        let preferences = NSUserDefaults.standardUserDefaults()
        let key = "NeuroMindVersion\(currentNeuroMindVersion)"
        if let _ = preferences.stringForKey(key) {
        // if 1 == 2 {      // for testing only
        } else {
            let storyboard = UIStoryboard(name: "ReleaseNotes", bundle: nil)
            let controller = storyboard.instantiateInitialViewController() as! ReleaseNotesVC
            let navigationController = UINavigationController(rootViewController: controller)
            preferences.setValue(currentNeuroMindVersion, forKey: key)
            splitViewController?.showDetailViewController(navigationController, sender: nil)
        }
        
        // Continue with loading menu
        super.viewDidLoad()
        iris = IRIS(version: currentNeuroMindVersion, statusURLString: "http://dign.eu/nm/neuromind.json", expirationTimeInDays: 30, eulaURLString: "http://dign.eu/eula")
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ScoreDetailVC
        }
        
        /*
        // Notify of iCloud sync
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyValueStoreDidChange:",
            name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification,
            object: keystore)
        */
        
        // Configure tableview
        sortScoresPerSection()
        
        // Configure search controller
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = resultSearchController.searchBar
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        iris.checkIfUserAcceptedEULA()
        // keystore.synchronize()
        tableView.reloadData()
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
        if filteredTableData.count > 0 {
            return filteredTableData[indexPath.row]
        } else {
            return scoresPerSection[indexPath.section][indexPath.row]
        }
    }
    
    
    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if filteredTableData.count > 0 {
            return 1
        } else {
            return allSections.count
        }
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if filteredTableData.count > 0 {
            return nil
        } else {
            return allSections[section]
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredTableData.count > 0 {
            return filteredTableData.count
        } else {
            return scoresPerSection[section].count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell", forIndexPath: indexPath) as! ScoreCell
        let score = scoreForCellAtIndexPath(indexPath)
        
        cell.nameLabel.text = score.name
        cell.descriptionLabel.text = score.topic
        configureFavoriteButtonForScore(score, inScoreCell: cell)
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let score = scoreForCellAtIndexPath(indexPath)
        resultSearchController.active = false

        // Message for legacy iPad version
        let kKeyRemainingUses = "remainingUses"
        let remainingUses = NSUserDefaults.standardUserDefaults().integerForKey(kKeyRemainingUses)
        NSUserDefaults.standardUserDefaults().setInteger(remainingUses + 1, forKey: kKeyRemainingUses)
        var legacyMessage = ""
        var blockContent = false
        let maxUses = 25
        
        if remainingUses > maxUses {
            legacyMessage = "You have no remaining uses left. \n\nPlease upgrade to the universal version of NeuroMind 3."
            blockContent = true
        } else {
            legacyMessage = "This version will not be supported anymore and will be removed from the App Store later in 2016. \n\nPlease download the universal version of NeuroMind 3 that works on both iPhone and iPad. \n\nYou have \(maxUses - remainingUses) remaining uses."
        }
        
        let iPadAlert = UIAlertController(title: "Warning", message: legacyMessage, preferredStyle: .Alert)
        let ignoreAction = UIAlertAction(title: "Ignore", style: .Destructive, handler: nil)
        if !blockContent { iPadAlert.addAction(ignoreAction) }
        let downloadAction = UIAlertAction(title: "Download now!", style: .Default) { (action) in
            let url = NSURL(string: "http://itunes.apple.com/us/app/neuromind/id353386909?mt=8")
            UIApplication.sharedApplication().openURL(url!)
        }
        iPadAlert.addAction(downloadAction)
        presentViewController(iPadAlert, animated: true, completion: nil)
        
        
        // Load content
        switch score.id {
        case 20:
            openStoryboardWithName("SLIC", asType: SLICTableViewController.self, forScore: score)
        case 22:
            openStoryboardWithName("TLICS", asType: TLICS_TVC.self, forScore: score)
        case 25:
            openStoryboardWithName("SpetzlerPonce", asType: SpetzlerPonceTVC.self, forScore: score)
        case 83:
            score.hasInAppPurchase = false
            openStoryboardWithName("ScoreDetail", asType: ScoreDetailVC.self, forScore: score)
        case 180:
            score.hasInAppPurchase = false
            openStoryboardWithName("ScoreDetail", asType: ScoreDetailVC.self, forScore: score)
        default:
            openStoryboardWithName("ScoreDetail", asType: ScoreDetailVC.self, forScore: score)
        }
    }
    
    
    // MARK:- Storyboard navigation
    
    
    func openStoryboardWithName<T: UIViewController where T: ContainsScore>(name: String, asType type: T.Type, forScore score: Score) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! T
        controller.title = score.name
        controller.score = score
        
        if score.hasInAppPurchase && NSUserDefaults.standardUserDefaults().stringForKey(score.productID) == nil {
            openPurchaseVCForScore(score)
        } else {
            let navigationController = UINavigationController(rootViewController: controller)
            splitViewController?.showDetailViewController(navigationController, sender: nil)
        }
    }
    
    
    func openPurchaseVCForScore(score: Score) {
        let storyboard = UIStoryboard(name: "Purchase", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! PurchaseVC
        controller.title = score.name
        controller.score = score
        let navigationController = UINavigationController(rootViewController: controller)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
    }
    
    
    func resetInAppPurchaseMemoryForScore(score: Score) {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: score.productID)
    }
    
    
    // MARK:- UISearchResultsUpdating protocol
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // Deactivate favorites mode
        let score = Score()
        showFavorites = false
        favoritesButton.image = UIImage(named: score.kFavorite)
        
        // Filter results
        filteredTableData.removeAll(keepCapacity: false)
        let searchText = searchController.searchBar.text
        filteredTableData = allScores.filter{$0.name.localizedCaseInsensitiveContainsString(searchText!) || $0.topic.localizedCaseInsensitiveContainsString(searchText!)}
        tableView.reloadData()
    }
    
    
    // MARK:- Favorites
    
    
    @IBAction func favoritesButtonTapped(sender: AnyObject) {
        let score = Score()
        showFavorites = !showFavorites
        
        if showFavorites {
            filteredTableData = allScores.filter{$0.isFavorite.boolValue == true}
            if filteredTableData.count > 0 {
                favoritesButton.image = UIImage(named: score.kFavoriteSelected)
            } else {
                showFavorites = false
                let alertController = UIAlertController(
                        title: "No favorites found",
                        message: "You have no favorite items yet. \n\nTap the star behind an item to add one.",
                        preferredStyle: .Alert
                )
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(okAction)
                presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            favoritesButton.image = UIImage(named: score.kFavorite)
            filteredTableData.removeAll(keepCapacity: false)
        }
        
        tableView.reloadData()
    }
    
    
    @IBAction func favoriteButtonInCellTapped(sender: AnyObject) {
        let cell = (sender.superview)!!.superview as! ScoreCell
        let indexPath = tableView.indexPathForCell(cell)
        let score = scoreForCellAtIndexPath(indexPath!)
        
        score.isFavorite = !score.isFavorite
        score.saveFavoriteStatus(score.isFavorite)
        configureFavoriteButtonForScore(score, inScoreCell: cell)
        tableView.reloadData()
    }
    
    
    func configureFavoriteButtonForScore(score: Score, inScoreCell scoreCell: ScoreCell) {
        if score.isFavorite {
            scoreCell.favoriteItemButton.setImage(UIImage(named: score.kFavoriteSelected), forState: .Normal)
        } else {
            scoreCell.favoriteItemButton.setImage(UIImage(named: score.kFavorite), forState: .Normal)
        }
    }
    
    
    /*
    func keyValueStoreDidChange(notification: NSNotification) {
        tableView.reloadData()
        print("iCloud updated: \(notification.description)")
    }
    */
    
    
    // MARK:- Info Button
    
    
    @IBAction func infoButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Info", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! InfoTVC
        let navigationController = UINavigationController(rootViewController: controller)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
    }
    
    
}
