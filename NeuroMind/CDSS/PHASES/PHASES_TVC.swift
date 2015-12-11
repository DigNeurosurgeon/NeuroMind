//
//  PHASES_TVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 07-12-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class PHASES_TVC: UITableViewController, ContainsScore {
    
    @IBOutlet weak var submitButton: UIButton!
    var score = Score()
    var cdss = PHASES()
    var selectedCellIndices = [-1,-1,-1,-1,-1,-1]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        submitButton.enabled = false
        
        // Add favorite button
        let favoriteIconImage = score.isFavorite ? UIImage(named: score.kFavoriteSelected) : UIImage(named: score.kFavorite)
        let favoriteBarButton = UIBarButtonItem(image: favoriteIconImage, style: .Plain, target: self, action: "setFavoriteStatus:")
        navigationItem.rightBarButtonItem = favoriteBarButton
    }
    
    
    // MARK:- Data processing
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCellIndices[indexPath.section] = indexPath.row
        Helper.updateSelectionAtIndexPath(indexPath, forTableView: tableView)
        let row = indexPath.row
        
        switch indexPath.section {
        case 0:
            cdss.population = PHASES.Population(rawValue: row)!
        case 1:
            cdss.hypertension = PHASES.YesNo(rawValue: row)!
        case 2:
            cdss.age = PHASES.Age(rawValue: row)!
        case 3:
            cdss.size = PHASES.Size(rawValue: row)!
        case 4:
            cdss.earlierSAH = PHASES.YesNo(rawValue: row)!
        case 5:
            cdss.site = PHASES.Site(rawValue: row)!
        default:
            break
        }
        
        if cdss.inputComplete {
            submitButton.enabled = true
        }
        
    }

    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        let controller = Helper.getRecommendationVCWithContent(cdss.risksAsHTML, forScore: score)
        controller.title = "Risk assessment"
        controller.contentAsCSV = cdss.csvFilePath
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - Set favorite status
    
    
    func setFavoriteStatus(barButton: UIBarButtonItem) {
        score.isFavorite = !score.isFavorite
        score.saveFavoriteStatus(score.isFavorite)
        
        if score.isFavorite {
            barButton.image = UIImage(named: score.kFavoriteSelected)
        } else {
            barButton.image = UIImage(named: score.kFavorite)
        }
    }
    
    
    // MARK:- Table data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cdss.sections.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cdss.sections[section]
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cdss.items[section].count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CDSS", forIndexPath: indexPath)
        cell.textLabel?.text = cdss.items[indexPath.section][indexPath.row]
        cell.accessoryType = selectedCellIndices[indexPath.section] == indexPath.row ? .Checkmark : .None
        return cell
    }

}
