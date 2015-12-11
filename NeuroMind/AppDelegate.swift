//
//  AppDelegate.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 22-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Configure split view controller
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        
        // Set global tint color
        window?.tintColor = UIColor.init(red: 16/255, green: 125/255, blue: 118/255, alpha: 1.0)
        
        // Load storyboard for testing
        // loadStoryboardForTestingInSplitViewController(splitViewController)
        
        return true
    }
    
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
        
    }
    
    
    func loadStoryboardForTestingInSplitViewController(splitViewController: UISplitViewController) {
        let storyboard = UIStoryboard(name: "PHASES", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! PHASES_TVC
        let testNavigationController = UINavigationController(rootViewController: controller)
        splitViewController.showDetailViewController(testNavigationController, sender: nil)
    }
    
}

