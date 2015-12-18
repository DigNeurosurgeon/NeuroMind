//
//  ScoresDetailViewController.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 25-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class ScoreDetailVC: UIViewController, ContainsScore {

    var score = Score()
    var productID: String?
    
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
        
       let scoreDetails =  "<html><head><style>" +
                "body {font-family: 'HelveticaNeue-Light', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, Arial, 'Lucida Grande', sans-serif;}" +
                "h1 {color: #107d76;}" +
                "h2 {color: gray;}" +
                "h3, h4 {color: white; background-color: #12a199; background: -webkit-linear-gradient(left, #107d76 , #12a199);}" +
                "#reference {background-color: darkgray;}" +
                "#reference-text {color: gray}" +
            "</style></head><body>" +
            "<h1>\(score.name)</h1>" +
            "<h2>\(score.topic)</h2>" +
            "\(score.content)" +
            "<h4 id=\"reference\">Reference</h4>" +
            "<p id=\"reference-text\">\(score.reference)</p>" +
        "</body></html>"
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
