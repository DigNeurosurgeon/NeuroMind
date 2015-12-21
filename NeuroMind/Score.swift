//
//  Score.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 22-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class Score {
    
    static let kEmptyString = ""
    static let FullAccessAvailable = "FullAccessAvailable"
    static let ProductID = "OrthoRef.FullAccess"
    
    let kFavorite = "Favorite"
    let kFavoriteSelected = "FavoriteSelected"
    let kOrthoRefProductID = "some value"
    
    var id: Int
    var name: String
    var topic: String
    var content: String
    var category: String
    var reference: String
    var hasInAppPurchase: Bool
    var productID: String
    var isFavorite: Bool
    
    var localDefaults = NSUserDefaults.standardUserDefaults()
    // var keystore = NSUbiquitousKeyValueStore()
    
    init(id: Int = 0, name: String = kEmptyString, topic: String = kEmptyString, content: String = kEmptyString, category: String = kEmptyString, reference: String = kEmptyString, availableInLiteVersion: Int = 0, isFavorite: Bool = false) {
        
        self.id = id
        self.name = name
        self.topic = topic
        self.content = content
        self.category = category
        self.reference = reference
        self.hasInAppPurchase = availableInLiteVersion == 0 ? true : false
        self.productID = hasInAppPurchase ? kOrthoRefProductID : ""
        
        self.isFavorite = isFavorite // provide default value
        // self.isFavorite = keystore.boolForKey(String(id)) // update from favorites
        if let savedValue: Bool = localDefaults.valueForKey(String(id)) as? Bool {
            self.isFavorite = savedValue
        }

    }
    
    
    func saveFavoriteStatus(status: Bool) {
//        keystore.setBool(status, forKey: String(id))
//        keystore.synchronize()
        localDefaults.setValue(status, forKey: String(id))
    }
    
}