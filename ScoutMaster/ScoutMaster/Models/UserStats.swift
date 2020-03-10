//
//  UserStats.swift
//  ScoutMaster
//
//  Created by Tia Lendor on 3/6/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

struct UserStats {
    
    
    var hikeCheckIns: Int
    var milesHiked: Int
    var altitudeHiked: Int //do we want altitude hiked in one day? or cummalative per year?
    var averagePace: Int
//    var creatorId:
    
    init (hikeCheckIns: Int, milesHiked: Int, altitudeHiked: Int, averagePace: Int) {
        self.hikeCheckIns = hikeCheckIns
        self.milesHiked = milesHiked
        self.altitudeHiked = altitudeHiked
        self.averagePace = averagePace
        
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let hikeCheckIns = dict["hikeCheckIns"] as? Int,
            let milesHiked = dict["milesHiked"] as? Int,
            let altitudeHiked = dict["altitudeHiked"] as? Int,
            let averagePace = dict["averagePace"] as? Int else {return nil}
    
    self.hikeCheckIns = hikeCheckIns
    self.milesHiked = milesHiked
    self.altitudeHiked = altitudeHiked
    self.averagePace = averagePace
    
    }
    

var fieldsDict: [String: Any] {
    return [
        "hikeCheckIns": self.hikeCheckIns,
        "milesHiked": self.milesHiked,
        "altitudeHiked": self.altitudeHiked,
        "averagePace": self.averagePace
        
    ]
}
}

