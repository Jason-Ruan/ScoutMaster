//
//  ScoutMasterTests.swift
//  ScoutMasterTests
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import XCTest
@testable import ScoutMaster

class ScoutMasterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHikingProjectFetchTrails() {
        let expectation = self.expectation(description: "Asynchronous call to HikingProject API completed successfully with at least 1 trail returned")
    
        Trail.getTrails(lat: 40.7043, long: -73.854) { (result) in
            switch result {
                case .failure(let error):
                    XCTFail("HikingProject API call for trails did not return a valid result, error: \(error)")
                case .success(let trailResults):
                    XCTAssert(trailResults.count > 0, "HikingProject API should return trails")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail("There was a timeout error while trying to get response from HikingProject API, error: \(error)")
            }
        }
        
    }
    
    func testDarkSkyFetchWeather() {
        let expectation = self.expectation(description: "Asynchronous call to DarkSky API completed successfully with weather forecast results")
    
        DarkSkyAPIClient.manager.fetchWeatherForecast(lat: 40.7043, long: -73.854) { (result) in
            switch result {
                case .failure(let error):
                    XCTFail("DarkSky API call for weather forecast did not return a valid result, error: \(error)")
                    
                case .success(let weatherForecast):
                    guard let hourlyForecast = weatherForecast.hourly?.data, let dailyForecast = weatherForecast.daily?.data else {
                        return XCTFail("DarkSky API result did not include data for hourly and daily forecasts")
                    }
                    XCTAssert(hourlyForecast.count > 0 && dailyForecast.count > 0, "DarkSky API should return both hourly and daily forecast data")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail("There was a timeout error while trying to get response from DarkSky API, error: \(error)")
            }
        }
    }

}
