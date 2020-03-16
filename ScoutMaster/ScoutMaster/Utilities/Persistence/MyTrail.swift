//
//  MyTrail.swift
//  ScoutMaster
//
//  Created by Sam Roman on 3/9/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation
import CoreLocation

struct MyTrail: Codable {
    var title: String
    var trailID: String
    var creatorID: String
    var description: String?
    var images: [Data]
    var difficulty: String
    var coordinate: [String]
    
    
    func getTrueCoordinates() -> [(Double,Double)] {
        var trueCoords = [(Double,Double)]()
        for i in coordinate {
            let components = i.components(separatedBy: ",")
            trueCoords.append(((Double(components[0])!), (Double(components[1])!)))
        }
        return trueCoords
    }
}
