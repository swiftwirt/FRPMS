//
//  OpenWeatherAPITests.swift
//  RxOpenWeather
//
//  Created by fnord on 2/5/17.
//  Copyright © 2017 Nikolas Burk. All rights reserved.
//

import XCTest
@testable import RxOpenWeatherMapAPI

class OpenWeatherAPITests: XCTestCase {
    let openWeatherAPI: RxOpenWeatherMapAPI!
    
    override func setUp() {
        super.setUp()
        openWeatherAPI = RXOpenWeatherMapAPI()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBuildURL() {
        var urlResult = openWeatherAPI.buildURLForWeatherForcast(for: .fiveDays, city: "San Francisco", temperatureUnit: .fahrenheit)
        
        XCTAssert(urlResult.absoluteString ==  "", "failed url build")
//        internal func buildURLForWeatherForcast(for forecastPeriod: RxOpenWeatherMapAPI.ForecastPeriod, city: String, temperatureUnit: TemperatureUnit) -> URL {
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
