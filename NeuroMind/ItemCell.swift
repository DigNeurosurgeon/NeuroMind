//
//  ScoreCell.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 04-11-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteItemButton: UIButton!
    var favoriteItemSelected = false
    
    
    @IBAction func favoriteItemButtonTapped(sender: AnyObject) {
        if favoriteItemSelected {
            favoriteItemButton.setImage(UIImage(named: "Favorite"), forState: .Normal)
        } else {
            favoriteItemButton.setImage(UIImage(named: "FavoriteSelected"), forState: .Normal)
        }
        
        favoriteItemSelected = !favoriteItemSelected
    }
    
}
