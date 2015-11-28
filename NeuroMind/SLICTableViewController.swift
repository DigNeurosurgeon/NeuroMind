//
//  SLICTableViewController.swift
//  SLIC
//
//  Created by Pieter Kubben on 09-07-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class SLICTableViewController: UITableViewController {
    
    @IBOutlet weak var statusBarButton: UIBarButtonItem!
    
    var score = Score()
    var cdss = SLIC()
    let sections = SLIC.sections
    let items = SLIC.items
    var selectedCellIndices = [Int]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCellIndices = cdss.selectedCellIndices
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
        
        if selectedCellIndices[indexPath.section] == indexPath.row {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let currentSection = indexPath.section
        let currentRow = indexPath.row

        // Uncheck previously selected cell
        if selectedCellIndices[currentSection] != currentRow {
            let oldRow = selectedCellIndices[currentSection]
            let oldPath = NSIndexPath(forRow: oldRow, inSection: currentSection)
            let oldCell = tableView.cellForRowAtIndexPath(oldPath)
            oldCell?.accessoryType = .None
            
            selectedCellIndices[currentSection] = currentRow
        }
        
        // Check selected cell
        if cell?.accessoryType == UITableViewCellAccessoryType.None {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        } 
        
        // Save corresponding value to score
        switch (currentSection) {
            case 0:
                cdss.morphology = currentRow
            case 1:
                cdss.discoLigamentousComplex = currentRow
            case 2:
                cdss.neurologicalStatus = currentRow
            default:
                print("An error occurred when assigning a value to slicScore")
        }
        
    }
    
    
    // MARK: - Navigation


    @IBAction func submitButtonTapped(sender: AnyObject) {
        let controller = Helper.getRecommendationVCWithContent(cdss.giveTreatmentRecommendation(), forScore: score)
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
