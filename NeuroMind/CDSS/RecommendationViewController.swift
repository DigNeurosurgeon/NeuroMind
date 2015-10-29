//
//  RecommendationViewController.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 29-10-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class RecommendationViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var content = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let formattedContent = "<html><body style='font-family: Arial'>\(content)</body></html>"
        webView.loadHTMLString(formattedContent, baseURL: nil)
        
    }

    
}
