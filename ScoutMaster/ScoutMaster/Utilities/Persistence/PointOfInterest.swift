//
//  PointOfInterest.swift
//  ScoutMaster
//
//  Created by Sam Roman on 3/9/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

struct PointOfInterest: Codable {
    
    let lat: Double
    let long: Double
    let type: String
    let title: String?
    let desc: String?
    
    var id: String {
        return "\(lat)\(long)".replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "")
    }
    
    
  
    
}
