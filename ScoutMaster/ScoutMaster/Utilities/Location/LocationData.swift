//
//  Network.swift
//  ScoutMaster
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//


import Foundation

// MARK: - LocationData
struct LocationData: Codable {
    let type: String?
    let features: [Feature]?
    
    static func getCoordinatesFromData(data: Data) throws -> [[Double]]? {
    do {
     let info = try JSONDecoder().decode(LocationData.self, from: data)
        return info.features?[0].geometry?.coordinates

    } catch {
        print(error)
        return []
    }
    }
}

// MARK: - Feature
struct Feature: Codable {
    let type: String?
    let properties: Properties?
    let geometry: Geometry?
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String?
    let coordinates: [[Double]]?
}

// MARK: - Properties
struct Properties: Codable {
    let name: String?
}

