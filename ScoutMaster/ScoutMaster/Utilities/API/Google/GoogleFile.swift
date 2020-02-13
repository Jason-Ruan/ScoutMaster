//
//  GoogleFile.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 2/13/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let results: [Resul]
    let status: String
}

// MARK: - Result
struct Resul: Codable {
    let addressComponents: [AddressComponent]
    let formattedAddress: String
    let geometry: Geo
    let placeID: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeID = "place_id"
        case types
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let longName, shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

// MARK: - Geometry
struct Geo: Codable {
    let bounds: Bounds
    let location: Location
    let locationType: String
    let viewport: Bounds

    enum CodingKeys: String, CodingKey {
        case bounds, location
        case locationType = "location_type"
        case viewport
    }
}

// MARK: - Bounds
struct Bounds: Codable {
    let northeast, southwest: Location
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}
