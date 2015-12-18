//
//  TLICS.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 03-12-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class TLICS {

    static let sections = ["Morphology", "Posterior Ligamentous Complex", "Neurological Status"]
    
    static let items = [
        ["No abnormality", "Compression", "+ Burst Fracture", "Translation / Rotation", "Distraction"] ,
        ["Intact", "Suspected / Indeterminate", "Injured"] ,
        ["Intact", "Nerve Root", "Complete Cord Injury", "Incomplete Cord Injury", "Cauda Equina Syndrome"]
    ]
    
    var morphology: Int
    var posteriorLigamentousComplex: Int
    var neurologicalStatus: Int
    var input = ["","",""]
    
    var final: Int {
        get {
            return morphology + posteriorLigamentousComplex + neurologicalStatus
        }
    }
    
    
    init(morphology: Int = -100, posteriorLigamentousComplex: Int = -100, neurologicalStatus: Int = -100) {
        self.morphology = morphology
        self.posteriorLigamentousComplex = posteriorLigamentousComplex
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
            fatalError("No TLICS score available.")
        }
        
        if showComponents {
            return "<body style=\"font-family: Arial; \"> " +
                "<h3>\(recommendation)</h3>" +
                "<h4>TLICS score: \(final)</h4>" +
                "<p class='info'>Components:<p>" +
                "<ul>" +
                "<li>Morphology: \(input[0])</li>" +
                "<li>Posterior Ligamentous complex: \(input[1])</li>" +
                "<li>Neurological status: \(input[2])</li>" +
                "</ul>" +
            "</body>"
        } else {
            return "<body style=\"font-family: Arial; \"> " +
                "<h3>\(recommendation)</h3>" +
            "</body>"
        }
        
    }
    
    
    func getParametersAsCSV() -> NSURL {
        let header = "morphology_input,morphology_score,posterior_ligamentous_complex_input,posterior_ligamentous_complex_score,neurological_status_input,neurological_status_score"
        let content = "\(input[0]),\(morphology),\(input[1]),\(posteriorLigamentousComplex),\(input[2]),\(neurologicalStatus)"
        return Helper.createFileWithDateAndParametersAsCSVForItem("tlics_score", withHeader: header, andContent: content)
    }
    
}
