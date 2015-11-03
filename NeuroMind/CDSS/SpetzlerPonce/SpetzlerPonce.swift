//
//  SpetzlerPonce.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 29-10-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class SpetzlerPonce {
    
    var size: Int
    var eloquence: Int
    var venousDrainage: Int
    
    
    init(size: Int = -100, eloquence: Int = -100, venousDrainage: Int = -100) {
        self.size = size
        self.eloquence = eloquence
        self.venousDrainage = venousDrainage
    }
    
    
    func giveRecommendation() -> String {
        let spetzlerMartinScore = size + eloquence + venousDrainage
        var spetzlerPonceClass = ""
        var treatmentSuggestion = ""
        var postopDeficitRisk = (percentage: 0, lower: 0, upper: 0)
        
        switch spetzlerMartinScore {
            case 1, 2:
                spetzlerPonceClass = "A"
                treatmentSuggestion = "Microsurgical resection"
                postopDeficitRisk.percentage = 8
                postopDeficitRisk.lower = 6
                postopDeficitRisk.upper = 10
            case 3:
                spetzlerPonceClass = "B"
                treatmentSuggestion = "Multimodality treatment"
                postopDeficitRisk.percentage = 18
                postopDeficitRisk.lower = 15
                postopDeficitRisk.upper = 22
            case 4, 5:
                spetzlerPonceClass = "C"
                treatmentSuggestion = "No treatment, with exception of recurrent hemorrhages, progressive neurological deficits, steal-related symptoms, and AVM-related aneurysms."
                postopDeficitRisk.percentage = 32
                postopDeficitRisk.lower = 27
                postopDeficitRisk.upper = 38
            default:
                return Helper.inputIncomplete
        }
        
        return  "<h3>Spetzler Ponce Class \(spetzlerPonceClass)" +
            
                "<h4>Spetzler Martin score \(spetzlerMartinScore)</h4>" +
            
                "<h4>Treatment suggestion</h4>" +
                "\(treatmentSuggestion)" +
        
                "<h4>Risk for postoperative deficit</h4>" +
                "\(postopDeficitRisk.percentage)% (95% CI \(postopDeficitRisk.lower)% - \(postopDeficitRisk.upper)%)"
    }
    
}


