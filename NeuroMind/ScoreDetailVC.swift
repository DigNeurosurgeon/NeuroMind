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
        let darkColor = "#99004c"
        let lightColor = "#cc0066"
        
       let scoreDetails =  "<html><head><style>" +
                "body {font-family: 'HelveticaNeue-Light', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, Arial, 'Lucida Grande', sans-serif;}" +
                "h1 {color: \(darkColor);}" +
                "h2 {color: gray;}" +
                "h3 {color: white; background-color: #107d76; background: -webkit-linear-gradient(left, \(darkColor) , \(lightColor));}" +
                "h4 {color: white; background-color: #12a199; background: -webkit-linear-gradient(left, \(lightColor) , \(darkColor)); width: 90%}" +
                "#reference {font-weight: bold; color: white; background-color: darkgray;}" +
                "#reference-text {color: gray}" +
            "</style></head><body>" +
            "<h1>\(score.name)</h1>" +
            "<h2>\(score.topic)</h2>" +
            "\(score.content)" +
            "<p id=\"reference\">Reference</p>" +
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
