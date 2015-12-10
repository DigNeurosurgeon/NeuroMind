//
//  Score.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 22-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class Score {
    
    let kFavorite = "Favorite"
    let kFavoriteSelected = "FavoriteSelected"
    
    var id: Int
    var name: String
    var topic: String
    var content: String
    var category: String
    var reference: String
    var cdssPresent: Bool
    var productID: String
    var isFavorite: Bool
    var hasInAppPurchase: Bool
    
    var localDefaults = NSUserDefaults.standardUserDefaults()
    // var keystore = NSUbiquitousKeyValueStore()
    
    init(id: Int = 0, name: String = "", topic: String = "", content: String = "", category: String = "", reference: String = "", cdss: Int = 0, productID: String = "", isFavorite: Bool = false) {
        
        self.id = id
        self.name = name
        self.topic = topic
        self.content = content
        self.category = category
        self.reference = reference
        self.cdssPresent = cdss == 1 ? true : false
        self.productID = productID
        self.hasInAppPurchase = productID.characters.count > 0 ? true : false
        
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