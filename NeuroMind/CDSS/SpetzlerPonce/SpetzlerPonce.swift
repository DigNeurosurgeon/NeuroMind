//
//  SpetzlerPonce.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 29-10-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class SpetzlerPonce {
    
    let sections = ["Size", "Eloquence", "Venous drainage"]
    let items = [
        [Size.UpToThreeCm.rawValue, Size.ThreeToSixCm.rawValue, Size.MoreThanSixCm.rawValue],
        [Eloquence.NonEloquent.rawValue, Eloquence.Eloquent.rawValue],
        [VenousDrainage.SuperficialOnly.rawValue, VenousDrainage.Deep.rawValue]
    ]
    
    enum Size: String {
        case UpToThreeCm = "< 3 cm"
        case ThreeToSixCm = "3 - 6 cm"
        case MoreThanSixCm = "> 6 cm"
    }
    
    enum Eloquence: String {
        case NonEloquent = "Non eloquent"
        case Eloquent = "Eloquent"
    }
    
    enum VenousDrainage: String {
        case SuperficialOnly = "Superficial Only"
        case Deep = "Deep"
    }
    
    var size: Int
    var eloquence: Int
    var venousDrainage: Int
    var spetzlerMartinScore: Int {
        return size + eloquence + venousDrainage
    }
    var input = ["", "", ""]
    
    
    init(size: Int = -100, eloquence: Int = -100, venousDrainage: Int = -100) {
        self.size = size
        self.eloquence = eloquence
        self.venousDrainage = venousDrainage
    }
    
    
    func giveRecommendation() -> String {
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
                "\(postopDeficitRisk.percentage)% (95% CI \(postopDeficitRisk.lower)% - \(postopDeficitRisk.upper)%)" +
        
                "<h4>Input parameters</h4>" +
                "<li>Size: \(input[0])</li>" +
                "<li>Eloquence: \(input[1])</li>" +
                "<li>Venous drainage: \(input[2])</li>"
    }
    
    
    func exportParametersAsCSV() -> NSURL {
        let header = "size_input,size_score,eloquence_input,eloquence_score,venous_drainage_input,venous_drainage_score"
        let content = "\(input[0]),\(size),\(input[1]),\(eloquence),\(input[2]),\(venousDrainage)"
        
        return Helper.createFileWithDateAndParametersAsCSVForItem("spetzler_ponce", withHeader: header, andContent: content)
    }
    
    
    
    
}


