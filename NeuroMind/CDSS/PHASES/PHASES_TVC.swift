//
//  PHASES_TVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 07-12-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class PHASES_TVC: UITableViewController, ContainsScore {
    
    var score = Score()
    var cdss = PHASES()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        // Add favorite button
        let favoriteIconImage = score.isFavorite ? UIImage(named: score.kFavoriteSelected) : UIImage(named: score.kFavorite)
        let favoriteBarButton = UIBarButtonItem(image: favoriteIconImage, style: .Plain, target: self, action: "setFavoriteStatus:")
        navigationItem.rightBarButtonItem = favoriteBarButton
    }
    
    
    
    // MARK:- Data processing
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Helper.updateSelectionAtIndexPath(indexPath, forTableView: tableView)
//        let row = indexPath.row
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        
//        switch indexPath.section {
//        case 0:
//            cdss.size = row + 1
//        case 1:
//            cdss.eloquence = row
//        case 2:
//            cdss.venousDrainage = row
//        default:
//            break
//        }
//        
//        cdss.input[indexPath.section] = (cell?.textLabel?.text)!
        
    }

    
    @IBAction func submitButtonTapped(sender: AnyObject) {
//        let controller = Helper.getRecommendationVCWithContent(cdss.giveRecommendation(), forScore: score)
//        controller.contentAsCSV = cdss.exportParametersAsCSV()
//        navigationController?.pushViewController(controller, animated: true)
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
        return cell
    }

}
