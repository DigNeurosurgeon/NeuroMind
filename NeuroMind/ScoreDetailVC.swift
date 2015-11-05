//
//  ScoresDetailViewController.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 25-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class ScoreDetailVC: UIViewController {

    var score = Score()
    
    @IBOutlet weak var scoreName: UINavigationItem!
    @IBOutlet weak var scoreWebView: UIWebView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreName.title = score.name
        
        let scoreDetails =  "<html><body style=\"font-family: Arial;\">" +
                            "<h1>\(score.name)</h1>" +
                            "<h2>\(score.topic)</h2>" +
                            "\(score.content)" +
                            "<h4><em>Reference</em></h4>" +
                            "<p><em>\(score.reference)</em></p>" +
                            "</body></html>"
        scoreWebView.loadHTMLString(scoreDetails, baseURL: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        configureFavoriteButton()
    }
    
    
    @IBAction func favoriteButtonForItemTapped(sender: AnyObject) {
        score.isFavorite = !score.isFavorite
        configureFavoriteButton()
    }
    
    
    func configureFavoriteButton() {
        if score.isFavorite {
            favoriteButton.image = UIImage(named: "FavoriteSelected")
        } else {
            favoriteButton.image = UIImage(named: "Favorite")
        }
    }
    
}
