//
//  ReleaseNotesVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 06-12-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class ReleaseNotesVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Release Notes"
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        loadReleaseNotes()
    }

    
    func loadReleaseNotes() {
        let url = NSBundle.mainBundle().URLForResource("release_notes", withExtension: "html")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }

}
