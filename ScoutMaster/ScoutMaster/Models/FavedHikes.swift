//
//  FavedHikes.swift
//  ScoutMaster
//
//  Created by Tia Lendor on 2/13/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

struct FavedHikes: Codable {
    
    var id: Int
    var name: String
    var type: String
    var summary: String
    var difficulty: String
    var location: String
    var url: String
    var img: String?
    var length: Double
    var ascent: Int
    var descent: Int
    var high: Int
    var low: Int
    var longitude: Double
    var latitude: Double
    var creatorId: String
    var favedId: String

    
    init(id: Int, name: String, type: String, summary: String, difficulty: String, location: String, url: String, img: String?, length: Double, ascent: Int, descent: Int, high: Int, low: Int, longitude: Double, latitude: Double, creatorId: String, favedId: String) {
        self.id = id
        self.name = name
        self.type = type
        self.summary = summary
        self.difficulty = difficulty
        self.location = location
        self.url = url
        self.img = img
        self.length = length
        self.ascent = ascent
        self.descent = descent
        self.high = high
        self.low = low
        self.longitude = longitude
        self.latitude = latitude
        self.creatorId = creatorId
        self.favedId = favedId
    }
    
    init?(from dict: [String: Any], faveId: String) {
        guard let id = dict["id"] as? Int,
            let name = dict["name"] as? String,
            let type = dict["type"] as? String,
            let summary = dict["summary"] as? String,
            let difficulty = dict["difficulty"] as? String,
            let location = dict["location"] as? String,
            let url = dict["url"] as? String,
            let img = dict["img"] as? String,
            let length = dict["length"] as? Double,
            let ascent = dict["ascent"] as? Int,
            let descent = dict["descent"] as? Int,
            let high = dict["high"] as? Int,
            let low = dict["low"] as? Int,
            let longitude = dict["longitude"] as? Double,
            let latitude = dict["latitude"] as? Double,
            let creatorId = dict["creatorId"] as? String else { return nil }
        
        self.id = id
        self.name = name
        self.type = type
        self.summary = summary
        self.difficulty = difficulty
        self.location = location
        self.url = url
        self.img = img
        self.length = length
        self.ascent = ascent
        self.descent = descent
        self.high = high
        self.low = low
        self.longitude = longitude
        self.latitude = latitude
        self.creatorId = creatorId
        self.favedId = faveId
    }


    
    var fieldsDict: [String: Any] {
        return [
            "id": self.id,
            "name": self.name,
            "type": self.type,
            "summary": self.summary,
            "difficulty": self.difficulty,
            "location": self.location,
            "url": self.url,
            "img": self.img ?? "",
            "length": self.length,
            "ascent": self.ascent,
            "descent": self.descent,
            "high": self.high,
            "low": self.low,
            "longitude": self.longitude,
            "latitude": self.latitude,
            "creatorId": self.creatorId
            
        ]
    }
}
