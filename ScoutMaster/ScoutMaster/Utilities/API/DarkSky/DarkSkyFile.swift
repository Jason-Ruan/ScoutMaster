//
//  DarkSkyFile.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 1/28/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

struct DarkSky: Codable {
    let timezone: String?
    let daily: SevenDayForecast?
    
    static func getWeather(lat: Double, long: Double, completionHandler: @escaping (Result<SevenDayForecast, AppError>) -> () ) {
        let urlStr = "https://api.darksky.net/forecast/\(Secrets.darkSky_key)/\(lat),\(long)"
        NetworkManager.shared.fetchData(urlString: urlStr) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let darkSkyResult = try JSONDecoder().decode(DarkSky.self, from: data)
                    guard let sevenDayForecast = darkSkyResult.daily else {
                        completionHandler(.failure(.badJSONError))
                        return
                    }
                    completionHandler(.success(sevenDayForecast))
                } catch let error {
                    print(error)
                    completionHandler(.failure(.badJSONError))
                }
            }
        }
    }
    
}


struct SevenDayForecast: Codable {
    let summary: String?
    let icon: String?
    let data: [DayForecast]?
    let alerts: [AlertsWrapper]?
}


struct DayForecast: Codable {
    let time: Int?
    let summary: String?
    let icon: String?
    let sunriseTime: Int?
    let sunsetTime: Int?
    let precipIntensityMax: Double?
    let temperatureHigh: Double?
    let temperatureLow: Double?
    let windSpeed: Double?
    let humidity: Double?
    let cloudCover: Double?
}

struct AlertsWrapper: Codable {
    let title: String?
    let time: Int?
    let expires: Int?
    let descriptiption: String?
    let uri: String?
}


