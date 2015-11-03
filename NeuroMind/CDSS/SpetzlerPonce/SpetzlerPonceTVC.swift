//
//  SpetzlerPonceTVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 29-10-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class SpetzlerPonceTVC: UITableViewController {
    
    var score = SpetzlerPonce()
    
    // MARK:- Data processing

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Helper.updateSelectionAtIndexPath(indexPath, forTableView: tableView)
        let row = indexPath.row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        switch indexPath.section {
            case 0:
                score.size = row + 1
            case 1:
                score.eloquence = row
            case 2:
                score.venousDrainage = row
            default:
                break
        }
        
        score.input[indexPath.section] = (cell?.textLabel?.text)!
        
    }
    
    
    @IBAction func onSubmit(sender: AnyObject) {
        let controller = Helper.getRecommendationVCWithContent(score.giveRecommendation())
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK:- Table data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return score.sections.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return score.sections[section]
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return score.items[section].count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "CDSS")
        cell.textLabel?.text = score.items[indexPath.section][indexPath.row]
        return cell
    }
    

}
