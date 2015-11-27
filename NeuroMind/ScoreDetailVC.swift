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
//    var keystore = NSUbiquitousKeyValueStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        configureView()
    }
    
    
    override func viewWillAppear(animated: Bool) {
//        keystore.synchronize()
        configureFavoriteButton()
    }
    
    
    var detailItem: Score? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        scoreName.title = score.name
        var scoreDetails = "<html><body style=\"font-family: Arial;\"><br/><br/><br/>" +
                            "<h4 style='text-align: center'>Please select an item from the menu.</h4>" +
                            "</body></html>"
        
        if score.name.characters.count > 0 {
            scoreDetails =  "<html><body style=\"font-family: Arial;\">" +
                "<h1>\(score.name)</h1>" +
                "<h2>\(score.topic)</h2>" +
                "\(score.content)" +
                "<h4><em>Reference</em></h4>" +
                "<p><em>\(score.reference)</em></p>" +
            "</body></html>"
        }
        scoreWebView.loadHTMLString(scoreDetails, baseURL: nil)
    }
    
    
    @IBAction func favoriteButtonForItemTapped(sender: AnyObject) {
        score.isFavorite = !score.isFavorite
        score.saveFavoriteStatus(score.isFavorite)
        configureFavoriteButton()
    }
    
    
    func configureFavoriteButton() {
        if score.isFavorite {
            favoriteButton.image = UIImage(named: score.kFavoriteSelected)
        } else {
            favoriteButton.image = UIImage(named: score.kFavorite)
        }
    }
    
}
