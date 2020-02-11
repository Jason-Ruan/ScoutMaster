//
//  HikingProjectFile.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 1/28/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

struct Trails: Codable {
    var trails: [Trail]
}

struct Trail: Codable {
    var id: Int
    var name: String
    var type: String
    var summary: String
    var difficulty: String
    var stars: Double
    var starVotes: Int
    var location: String
    var url: String
    var imgSqSmall: String
    var imgSmall: String
    var ingSmallMed: String?
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
    
    static func getTrails(lat: Double, long: Double, completionHandler: @escaping (Result<[Trail],AppError>) -> () ) {
        let urlStr = "https://www.hikingproject.com/data/get-trails?lat=\(lat)&lon=\(long)&maxDistance=20&key=\(Secrets.hiking_key)"
        NetworkManager.shared.fetchData(urlString: urlStr) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let HPtrails = try JSONDecoder().decode(Trails.self, from: data)
                    completionHandler(.success(HPtrails.trails))
                } catch let error {
                    print(error)
                    
                    completionHandler(.failure(.badJSONError))                }
            }
        }
    }
}


