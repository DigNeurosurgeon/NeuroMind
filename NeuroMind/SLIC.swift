//
//  SLICS.swift
//  SLIC
//
//  Created by Pieter Kubben on 26-07-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class SLIC {
    
    static let sections = ["Morphology", "Disco-Ligamentous Complex", "Neurological Status"]
    
    static let items = [
        ["No abnormality", "Compression", "+ Burst Fracture", "Distraction", "Rotation / Translation"] ,
        ["Intact", "Indeterminate", "Disrupted"] ,
        ["Intact", "Root injury", "Complete Cord Injury", "Incomplete Cord Injury", "Cord Compression with neurol deficit"]
    ]
    
    var morphology: Int
    var discoLigamentousComplex: Int
    var neurologicalStatus: Int
    var selectedCellIndices = [-1, -1, -1]
    
    var final: Int {
        get {
            return morphology + discoLigamentousComplex + neurologicalStatus
        }
    }
    
    
    init(morphology: Int = -100, discoLigamentousComplex: Int = -100, neurologicalStatus: Int = -100) {
        self.morphology = morphology
        self.discoLigamentousComplex = discoLigamentousComplex
        self.neurologicalStatus = neurologicalStatus
    }
    
    
    func giveTreatmentRecommendation() -> String {
        var recommendation = ""
        var showComponents = true
        
        switch final {
            case _ where final < 0:
                recommendation = "Please enter all fields."
                showComponents = false
            case 0...3:
                recommendation = "Conservative treatment recommended."
            case 4:
                recommendation = "Consider for operative or non-operative intervention."
            case _ where final > 4:
                recommendation = "Operative treatment recommended."
            default:
                fatalError("No SLIC score available.")
        }
        
        if showComponents {
            return "<body style=\"font-family: Arial; \"> " +
                "<h3>\(recommendation)</h3>" +
                "<h4>SLIC score: \(final)</h4>" +
                "<p>Components:<p>" +
                "<ul>" +
                "<li>Morphology: \(morphology)</li>" +
                "<li>Disco-ligamentous complex: \(discoLigamentousComplex)</li>" +
                "<li>Neurological status: \(neurologicalStatus)</li>" +
                "</ul>" +
                "</body>"
        } else {
            return "<body style=\"font-family: Arial; \"> " +
            "<h3>\(recommendation)</h3>" +
            "</body>"
        }
        
    }
    
}