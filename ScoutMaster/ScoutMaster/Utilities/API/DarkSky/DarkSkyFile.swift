//
//  DarkSkyFile.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 1/28/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation
import UIKit

public enum ForecastType {
    case daily
    case hourly
}

public func convertTimeToDate(forecastType: ForecastType, time: Int) -> String {
    let dateInput = Date(timeIntervalSince1970: TimeInterval(exactly: time) ?? 0)
    let formatter = DateFormatter()
    switch forecastType {
        case .daily:
            formatter.dateFormat = "E M/d"
        case .hourly:
            formatter.dateFormat = "E - h a"
    }
    formatter.locale = .current
    return formatter.string(from: dateInput)
}

public func getWeatherIcon(named: String) -> UIImage {
    switch named {
        case "clear-day":
            return UIImage(systemName: "sun.max.fill")!
        case "clear-night":
            return UIImage(systemName: "moon.fill")!
        case "wind":
            return UIImage(systemName: "wind")!
        case "rain":
            return UIImage(systemName: "cloud.rain.fill")!
        case "sleet":
            return UIImage(systemName: "cloud.sleet.fill")!
        case "snow":
            return UIImage(systemName: "cloud.snow.fill")!
        case "fog":
            return UIImage(systemName: "cloud.fog.fill")!
        case "cloudy":
            return UIImage(systemName: "cloud.fill")!
        case "hail":
            return UIImage(systemName: "cloud.hail.fill")!
        case "thunderstorm":
            return UIImage(systemName: "cloud.bolt.rain.fill")!
        case "tornado":
            return UIImage(systemName: "tornado")!
        default:
            return UIImage(systemName: "cloud.sun.fill")!
    }
}


//MARK: - DarkSky API Client

class DarkSkyAPIClient {
    private init() {}
    static let manager = DarkSkyAPIClient()
    
    // Gets back WeatherForecast object with both daily and hourly forecasts
    func fetchWeatherForecast(lat: Double, long: Double, completionHandler: @escaping (Result<WeatherForecast, AppError>) -> () ) {
        
        let urlStr = "https://api.darksky.net/forecast/\(Secrets.darkSky_key)/\(lat),\(long)"
        
        NetworkManager.shared.fetchData(urlString: urlStr, completionHandler: { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let darkSkyResult = try JSONDecoder().decode(WeatherForecast.self, from: data)
                    guard let _ = darkSkyResult.daily, let _ = darkSkyResult.hourly else {
                        completionHandler(.failure(.badJSONError))
                        return
                    }
                    completionHandler(.success(darkSkyResult))
                } catch let error {
                    completionHandler(.failure(.other(errorDescription: error.localizedDescription)))
                }
            }
        })
    }
    
}

//MARK: - Weather Forecast Object w/ Daily and Hourly

struct WeatherForecast: Codable {
    let timezone: String?
    let daily: DailyForecast?
    let hourly: HourlyForecast?
    
    struct DailyForecast: Codable {
        let summary: String?
        let icon: String?
        let data: [DayForecastDetails]?
        let alerts: [AlertsWrapper]?
    }

    struct HourlyForecast: Codable {
        let summary: String?
        let icon: String?
        let data: [HourForecastDetails]?
    }

    struct AlertsWrapper: Codable {
        let title: String?
        let time: Int?
        let expires: Int?
        let descriptiption: String?
        let uri: String?
    }

    
}

//MARK: - Daily Forecast Details

struct DayForecastDetails: Codable {
    let time: Int?
    let summary: String?
    let icon: String?
    let sunriseTime: Int?
    let sunsetTime: Int?
    let precipIntensityMax: Double?
    let precipProbability: Double?
    let precipType: String?
    let temperatureHigh: Double?
    let temperatureLow: Double?
    let apparentTemperatureHigh: Double?
    let windSpeed: Double?
    let humidity: Double?
    let cloudCover: Double?
    let visibility: Double?
}


//MARK: - Hourly Forecast Details

struct HourForecastDetails: Codable {
    let time: Int?
    let summary: String?
    let icon: String?
    let precipIntensity: Double?
    let precipProbability: Double?
    let precipType: String?
    let temperature: Double?
    let apparentTemperature: Double?
    let humidity: Double?
    let windSpeed: Double?
    let cloudCover: Double?
    let visibility: Double?
}
