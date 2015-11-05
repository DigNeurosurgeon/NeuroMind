//
//  Score.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 22-09-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class Score {
    
    var id: Int
    var name: String
    var topic: String
    var content: String
    var category: String
    var reference: String
    var cdssPresent: Bool
    var storyboardName: String
    var isFavorite: Bool
    
    init(id: Int = 0, name: String = "", topic: String = "", content: String = "", category: String = "", reference: String = "", cdss: Int = 0, storyboardName: String = "", isFavorite: Bool = false) {
        
        self.id = id
        self.name = name
        self.topic = topic
        self.content = content
        self.category = category
        self.reference = reference
        self.cdssPresent = cdss == 1 ? true : false
        self.storyboardName = storyboardName
        self.isFavorite = isFavorite
    }
    
}