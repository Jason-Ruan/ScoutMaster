//
//  NPSFile.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 1/28/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

// MARK: - Parks
struct NPSResults: Codable {
    let total: String
    let data: [Park]
    let limit, start: String
}

// MARK: - Datum
struct Park: Codable {
    let states, latLong, description, designation: String
    let parkCode, id, directionsInfo: String
    let directionsURL: String
    let fullName: String
    let url: String
    let weatherInfo: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case states, latLong, description
        case designation, parkCode, id, directionsInfo
        case directionsURL = "directionsUrl"
        case fullName, url, weatherInfo, name
    }
    
    static func getParks(stateCode: String, completionHandler: @escaping (Result<[Park], AppError>) -> () ) {
        let urlStr = "https://developer.nps.gov/api/v1/parks?stateCode=NY&q=trail&api_key=\(Secrets.nps_key)"
        NetworkManager.shared.fetchData(urlString: urlStr) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let npsResults = try JSONDecoder().decode(NPSResults.self, from: data)
                    let parks = npsResults.data
                    
                    // Can filter out results for designation property here
                    // let filteredParks = parks.filter { !$0.designation.contains("INSERT_FILTER_TERM")}
                    
                    completionHandler(.success(parks))
                } catch let error {
                    print(error)
                    completionHandler(.failure(.badJSONError))
                }
            }
        }
    }
    
}

