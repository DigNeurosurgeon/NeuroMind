//
//  TLICS_TVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 03-12-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class TLICS_TVC: UITableViewController, ContainsScore {
    
    var score = Score()
    var cdss = TLICS()
    let sections = TLICS.sections
    let items = TLICS.items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        // Add favorite button
        let favoriteIconImage = score.isFavorite ? UIImage(named: score.kFavoriteSelected) : UIImage(named: score.kFavorite)
        let favoriteBarButton = UIBarButtonItem(image: favoriteIconImage, style: .Plain, target: self, action: "setFavoriteStatus:")
        navigationItem.rightBarButtonItem = favoriteBarButton
    }
    
    
    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return sections.count
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items[section].count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CDSS", forIndexPath: indexPath)
        cell.textLabel?.text = items[indexPath.section][indexPath.row]
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Helper.updateSelectionAtIndexPath(indexPath, forTableView: tableView)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        
        // Save corresponding value to score
        switch (currentSection) {
        case 0:
            cdss.morphology = currentRow
            cdss.input[0] = (cell?.textLabel?.text)!
        case 1:
            cdss.posteriorLigamentousComplex = (currentRow == 0) ? currentRow : currentRow + 1
            cdss.input[1] = (cell?.textLabel?.text)!
        case 2:
            switch currentRow {
            case 0:
                cdss.neurologicalStatus = 0
            case 1, 2:
                cdss.neurologicalStatus = 2
            case 3, 4:
                cdss.neurologicalStatus = 3
            default:
                break
            }
            cdss.input[2] = (cell?.textLabel?.text)!
        default:
            break
        }
        
    }
    
    
    // MARK: - Navigation
    
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        let controller = Helper.getRecommendationVCWithContent(cdss.giveTreatmentRecommendation(), forScore: score)
        controller.contentAsCSV = cdss.getParametersAsCSV()
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

}
