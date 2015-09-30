//
//  ScoresDetailViewController.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 25-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class ScoresDetailViewController: UIViewController {

    var score = Score()
    
    @IBOutlet weak var scoreName: UINavigationItem!
    @IBOutlet weak var scoreWebView: UIWebView!
    
    
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
    
}
