//
//  SINS.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 15-12-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class SINS {
    
    let sections = ["Location", "Pain relief with recumbency and/or pain with movement/loading of the spine", "Bone lesion", "Radiographic spinal alignemnt", "Vertebral body collapse", "Posterolateral involvement of the spinal elements (facet, pedicle or costovertebral joint fracture or replacement with tumor)"]
    
    let items = [
        ["Junctional (occiput-C2, C7-T2, T11-L1, L5-S1)", "Mobile spine (C3-C6, L2-L4", "Semi-rigid (T3-T10)", "Rigid (S2-S5)"],
        ["Yes", "No (occasional pain but not mechanical)", "Pain free lesion"],
        ["Lytic", "Mixed (lytic/blastic)", "Blastic"],
        ["Subluxation/translation present", "De novo deformity (kyphosis/scoliosis", "Normal alignment"],
        ["> 50% collapse", "< 50% collapse", "No collapse with > 50% body involved", "None of the above"],
        ["Bilateral", "Unilateral", "None of the above"]
    ]
    
    static let kUnselected = -100
    let kUnselected = -100
    let kUnselectedText = ""
    
    
    // MARK:- Input parameters
    
    
    // MARK: Location
    
    var locationIndex: Int
    var locationItem: String {
        return locationIndex < 0 ? kUnselectedText : items[0][locationIndex]
    }
    var locationPoints: Int {
        let points = [3, 2, 1, 0]
        return locationIndex < 0 ? kUnselected : points[locationIndex]
    }
    
    // MARK: Pain
    
    var painIndex: Int
    var painItem: String {
        return painIndex < 0 ? kUnselectedText : items[1][painIndex]
    }
    var painPoints: Int {
        let points = [3, 1, 0]
        return painIndex < 0 ? kUnselected : points[painIndex]
    }
    
    // MARK: Bone lesion
    
    var boneLesionIndex: Int
    var boneLesionItem: String {
        return boneLesionIndex < 0 ? kUnselectedText : items[2][boneLesionIndex]
    }
    var boneLesionPoints: Int {
        let points = [2, 1, 0]
        return boneLesionIndex < 0 ? kUnselected : points[boneLesionIndex]
    }
    
    // MARK: Spinal alignment
    
    var spinalAlignmentIndex: Int
    var spinalAlignmentItem: String {
        return spinalAlignmentIndex < 0 ? kUnselectedText : items[3][spinalAlignmentIndex]
    }
    var spinalAlignmentPoints: Int {
        let points = [4, 2, 0]
        return spinalAlignmentIndex < 0 ? kUnselected : points[spinalAlignmentIndex]
    }
    
    // MARK: Vertebral body collapse
    
    var vertebralBodyCollapseIndex: Int
    var vertebralBodyCollapseItem: String {
        return vertebralBodyCollapseIndex < 0 ? kUnselectedText : items[4][vertebralBodyCollapseIndex]
    }
    var vertebralBodyCollapsePoints: Int {
        let points = [3, 2, 1, 0]
        return vertebralBodyCollapseIndex < 0 ? kUnselected : points[vertebralBodyCollapseIndex]
    }
    
    // MARK: Posterolateral elements involvement
    
    var posteroLateralInvolvementIndex: Int
    var posteroLateralInvolvementItem: String {
        return posteroLateralInvolvementIndex < 0 ? kUnselectedText : items[5][posteroLateralInvolvementIndex]
    }
    var posteroLateralInvolvementPoints: Int {
        let points = [3, 1, 0]
        return posteroLateralInvolvementIndex < 0 ? kUnselected : points[posteroLateralInvolvementIndex]
    }
    
    
    // MARK:- Output parameters
    
    
    var totalPoints: Int {
        return locationPoints + painPoints + boneLesionPoints + spinalAlignmentPoints + vertebralBodyCollapsePoints + posteroLateralInvolvementPoints
    }
    
    
    var inputIsComplete: Bool {
        return totalPoints < 0 ? false : true
    }
    
    
    var conclusion: String {
        var summary = ""
        switch totalPoints {
        case _ where totalPoints >= 0 && totalPoints <= 6:
            summary = "Stable spine"
        case _ where totalPoints >= 7 && totalPoints <= 12:
            summary = "Indeterminate (possibly impending) instability"
        case _ where totalPoints >= 13:
            summary = "Instable spine"
        default:
            summary = "Input is incomplete."
        }
        
        return summary
    }
    
    
    var surgicalConsultationWarranted: Bool {
        return totalPoints >= 7 ? true : false
    }
    
    
    var recommendation: String {
        let surgicalConsultation = surgicalConsultationWarranted ? "<p>Surgical consultation is warranted.</p>" : ""
        
        return  "<h3>\(conclusion)</h3>" +
                "\(surgicalConsultation)" +
                "<p class='info'>Input parameters:</p>" +
                "<ul>" +
                    "<li>Location: \(locationItem)</li>" +
                    "<li>Pain: \(painItem)</li>" +
                    "<li>Bone lesion: \(boneLesionItem)</li>" +
                    "<li>Spinal alignment: \(spinalAlignmentItem)</li>" +
                    "<li>Vertebral body collapse: \(vertebralBodyCollapseItem)</li>" +
                    "<li>Posterolateral involvement: \(posteroLateralInvolvementItem)</li>" +
                "</ul>"
    }
    
    
    var csvFilePath: NSURL {
        let header = "location,location_points,pain,pain_points,bone_lesion,bone_lesion_points,spinal_alignment,spinal_alignment_points,verbral_body_collapse,verbral_body_collapse_points,posterolateral_involvement,posterolateral_involvement_points,total_points,conclusion,surgical_consultation_warranted"
        let content = "\(locationItem),\(locationPoints),\(painItem),\(painPoints),\(boneLesionItem),\(boneLesionPoints),\(spinalAlignmentItem),\(spinalAlignmentPoints),\(vertebralBodyCollapseItem),\(vertebralBodyCollapsePoints),\(posteroLateralInvolvementItem),\(posteroLateralInvolvementPoints),\(totalPoints),\(conclusion),\(surgicalConsultationWarranted)"
        return Helper.createFileWithDateAndParametersAsCSVForItem("SINS", withHeader: header, andContent: content)
    }
    
    
    // MARK:- Init
    
    
    init(locationIndex: Int = kUnselected, painIndex: Int = kUnselected, boneLesionIndex: Int = kUnselected, spinalAlignmentIndex: Int = kUnselected, vertebralBodyCollapseIndex: Int = kUnselected, posteroLateralInvolvementIndex: Int = kUnselected) {
        self.locationIndex = locationIndex
        self.painIndex = painIndex
        self.boneLesionIndex = boneLesionIndex
        self.spinalAlignmentIndex = spinalAlignmentIndex
        self.vertebralBodyCollapseIndex = vertebralBodyCollapseIndex
        self.posteroLateralInvolvementIndex = posteroLateralInvolvementIndex
    }
    
}