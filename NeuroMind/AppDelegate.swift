//
//  AppDelegate.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 22-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window?.tintColor = UIColor.init(red: 0.1, green: 0.5, blue: 0.1, alpha: 1.0)
        return true
    }


}

