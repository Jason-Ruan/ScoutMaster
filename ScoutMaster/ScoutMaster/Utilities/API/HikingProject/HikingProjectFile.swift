//
//  HikingProjectFile.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 1/28/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

struct Trails {
    var trail: [Trail]
}

struct Trail: Codable {
    var id: Int
    var name: String
    var type: String
    var summary: String
    var difficulty: String
    var stars: Int
    var starVotes: Int
    var location: String
    var url: String
    var imgSqSmall: String
    var imgSmall: String
    var ingSmallMed: String
    var imgMedium: String
    var length: Double
    var ascent: Int
    var descent: Int
    var high: Int
    var low: Int
    var longitude: Double
    var latitude: Double
    var conditionStatus: String
    var conditionDetails: String?
    var conditionDate: String
}
