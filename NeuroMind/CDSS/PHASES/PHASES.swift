//
//  PHASES.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 07-12-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class PHASES {
    
    let sections = ["Population", "Hypertension", "Age", "Size of aneurysm", "Earlier SAH from another aneurysm", "Site of aneurysm"]
    
    let items = [
        ["North American, European (other than Finnish)", "Japanese", "Finnish"],
        ["No", "Yes"],
        ["< 70 years", "\u{2265} 70 years"],
        ["< 7.0 mm", "7.0 - 9.9 mm", "10.0 - 19.9 mm", "\u{2265} 20 mm"],
        ["No", "Yes"],
        ["Internal Cerebral Artery", "Medial Cerebral Artery", "Anterior Cerebral Artery", "Posterior Cerebral Artery", "Communicating Posterior Artery"]
    ]
    
    let points = [
        [0, 3, 5],
        [0, 1],
        [0, 1],
        [0, 3, 6, 10],
        [0, 1],
        [0, 2, 4, 4, 4]
    ]
    
    let kInputIncomplete = "Please answer all questions."
    
    
    enum YesNo: Int {
        case Unselected = -1, No, Yes
    }
    
    enum Population: Int {
        case Unselected = -1, NorthAmericanEuropean, Japanese, Finnish
    }
    
    enum Age: Int {
        case Unselected = -1, YoungerThan70, SeventyOrOlder
    }
    
    enum Size: Int {
        case Unselected = -1, LessThanSevenMm, SevenToTenMm, TenToTwentyMm, TwentyOrMoreMm
    }
    
    enum Site: Int {
        case Unselected = -1, ICA, MCA, ACA, PCA, Pcomm
    }
    
    
    // MARK:- Variables
    
    var population: Population
    var hypertension: YesNo
    var age: Age
    var size: Size
    var earlierSAH: YesNo
    var site: Site
    
    
    // MARK:- Computed properties
    
    var inputComplete: Bool {
        if population == .Unselected || hypertension == .Unselected || age == .Unselected || size == .Unselected || earlierSAH == .Unselected || site == .Unselected {
            return false
        } else {
            return true
        }
    }
    
    
    var sumScore: Int {
        if inputComplete {
            var subtotal = [Int]()
            var counter = 0
            subtotal.append(points[0][population.rawValue])
            subtotal.append(points[1][hypertension.rawValue])
            subtotal.append(points[2][age.rawValue])
            subtotal.append(points[3][size.rawValue])
            subtotal.append(points[4][earlierSAH.rawValue])
            subtotal.append(points[5][site.rawValue])
            
            for sub in subtotal {
                counter += sub
            }
            
            return counter
        } else {
            return -1
        }

    }
    
    
    var risks: (risk: Double, ciLower: Double, ciUpper: Double)  {
        var result = (risk: 0.0, ciLower: 0.0, ciUpper: 0.0)
        let stats: [(Double, Double, Double)] = [
            (0.4, 0.1, 1.5),
            (0.7, 0.2, 1.5),
            (0.9, 0.3, 2.0),
            (1.3, 0.8, 2.4),
            (1.7, 1.1, 2.7),
            (2.4, 1.6, 3.3),
            (3.2, 2.3, 4.4),
            (4.3, 2.9, 6.1),
            (5.3, 3.5, 8.0),
            (7.2, 5.0, 10.2),
            (17.8, 15.2, 20.7)
        ]
        let max = stats.count - 1
        
        if sumScore <= 2 {
            result = (risk: stats[0].0, ciLower: stats[0].1, ciUpper: stats[0].2)
        } else if sumScore >= 12 {
            result = (risk: stats[max].0, ciLower: stats[max].1, ciUpper: stats[max].2)
        } else {
            for i in 1..<max {
                result = (risk: stats[i].0, ciLower: stats[i].1, ciUpper: stats[i].2)
            }
        }
        
        return result
    }
    
    
    var risksAsHTML: String {
        return "<h3>5 year risk: \(risks.risk)% (95% CI \(risks.ciLower)%-\(risks.ciUpper)%)</h3>" +
                "<p>This is the 5 year risk of aneurysm rupture based on these parameters:</p>" +
                "<ul>" +
                    "<li>Population: \(items[0][population.rawValue])</li>" +
                    "<li>Age: \(items[1][age.rawValue])</li>" +
                    "<li>Hypertension: \(items[2][hypertension.rawValue])</li>" +
                    "<li>Size: \(items[3][size.rawValue])</li>" +
                    "<li>Earlier SAH: \(items[4][earlierSAH.rawValue])</li>" +
                    "<li>Site: \(items[5][site.rawValue])</li>" +
                "</ul>"
    }
    
    
    var csvFilePath: NSURL {
        let header = "population,population_points,age,age_points,hypertension,hypertension_points,size,size_points,earlier_sah,earlier_sah_points,site,site_points,risk,ci_lower,ci_upper"
        let content = "\(items[0][population.rawValue),\(points[0][population.rawValue),\(items[1][age.rawValue),\(points[1][age.rawValue),\(items[2][hypertension.rawValue),\(points[2][hypertension.rawValue),\(items[3][size.rawValue]),\(points[3][size.rawValue]),\(items[4][earlierSAH.rawValue]),\(points[4][earlierSAH.rawValue]),\(items[5][site.rawValue]),\(points[5][site.rawValue]),\(risks.risk),\(risks.ciLower),\(risks.ciUpper)"
        return Helper.createFileWithDateAndParametersAsCSVForItem("PHASES", withHeader: header, andContent: content)
    }
    
    
    // MARK:- Methods
    
    
    init(population: Population = .Unselected, hypertension: YesNo = .Unselected, age: Age = .Unselected, size: Size = .Unselected, earlierSAH: YesNo = .Unselected, site: Site = .Unselected) {
        self.population = population
        self.hypertension = hypertension
        self.age = age
        self.size = size
        self.earlierSAH = earlierSAH
        self.site = site
    }
    
}