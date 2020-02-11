//
//  NPSFile.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 1/28/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

// MARK: - Parks
struct NationalStateParks: Codable {
    let total: String
    let parks: [Park]
    let limit, start: String
    
    enum CodingKeys: String, CodingKey {
        case total, limit, start
        case parks = "data"
    }
    
}

// MARK: - Park
struct Park: Codable {
//    let contacts: Contacts
    let states: String
    let entranceFees: [Entrance]
//    let directionsInfo: String
    let entrancePasses: [Entrance]
    let directionsURL: String
    let url: String
    let weatherInfo: String
    let name: String
    let operatingHours: [OperatingHour]
    let latLong, datumDescription: String
    
    let images: [Image]
    let designation, parkCode: String
    let addresses: [Address]
    let id, fullName: String
    
    enum CodingKeys: String, CodingKey {
        case  states, entranceFees, entrancePasses
        case directionsURL = "directionsUrl"
        case url, weatherInfo, name, operatingHours, latLong
        case datumDescription = "description"
        case images, designation, parkCode, addresses, id, fullName
    }
    
    static func getParks(stateCode: String, completionHandler: @escaping (Result<[Park], AppError>) -> () ) {
//        let urlStr = "https://developer.nps.gov/api/v1/parks?stateCode=NY&fields=images%2Ccontacts%2Caddresses%2CdirectionsInfo%2CoperatingHours%2CentranceFees%2CentrancePasses&api_key=\(Secrets.nps_key)"
        let urlStr = "https://developer.nps.gov/api/v1/parks?stateCode=NY&fields=images%2Caddresses%2CoperatingHours%2CentranceFees%2CentrancePasses&api_key=\(Secrets.nps_key)"
        let start = CFAbsoluteTimeGetCurrent()
        NetworkManager.shared.fetchData(urlString: urlStr) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let npsResults = try JSONDecoder().decode(NationalStateParks.self, from: data)
                    let parks = npsResults.parks
                    print("Time elapsed: \(CFAbsoluteTimeGetCurrent() - start)")
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

// MARK: - Address
struct Address: Codable {
    let postalCode, city: String
    let stateCode: String
    let line1: String
    let line2: String
    let line3: String
}


// MARK: - Contacts
struct Contacts: Codable {
    let phoneNumbers: [PhoneNumber]
    let emailAddresses: [EmailAddress]
}

// MARK: - EmailAddress
struct EmailAddress: Codable {
    let emailAddress: String
}

// MARK: - PhoneNumber
struct PhoneNumber: Codable {
    let phoneNumber, phoneNumberDescription, phoneNumberExtension: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber
        case phoneNumberDescription = "description"
        case phoneNumberExtension = "extension"
        case type
    }
}

// MARK: - Entrance
struct Entrance: Codable {
    let cost, entranceDescription, title: String
    
    enum CodingKeys: String, CodingKey {
        case cost
        case entranceDescription = "description"
        case title
    }
}

// MARK: - Image
struct Image: Codable {
    let credit, altText, title, id: String
    let caption: String
    let url: String
}

// MARK: - OperatingHour
struct OperatingHour: Codable {
    let exceptions: [Exception]
    let operatingHourDescription: String
    let standardHours: Hours
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case exceptions
        case operatingHourDescription = "description"
        case standardHours, name
    }
}

// MARK: - Exception
struct Exception: Codable {
    let exceptionHours: Hours
    let startDate, name, endDate: String
}

// MARK: - Hours
struct Hours: Codable {
    let monday, tuesday, wednesday, thursday, friday, saturday, sunday: String?
}


