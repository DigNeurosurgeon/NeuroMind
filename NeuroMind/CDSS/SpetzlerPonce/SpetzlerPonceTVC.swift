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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Helper.updateSelectionAtIndexPath(indexPath, forTableView: tableView)
        let row = indexPath.row
        
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
        
    }
    
    
    @IBAction func onSubmit(sender: AnyObject) {
        let controller = Helper.initRecommendationController()
        controller.content = score.giveRecommendation()
        navigationController?.pushViewController(controller, animated: true)
    }
    

}
