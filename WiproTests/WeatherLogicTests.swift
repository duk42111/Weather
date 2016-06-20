//
//  WeatherViewModelTests.swift
//  Wipro
//
//  Created by Mladen Despotovic on 23/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Wipro

class WeatherViewModelTests: XCTestCase {
    
    override func setUp() {
        
        super.setUp()

    }
    
    override func tearDown() {
        

        super.tearDown()
    }
    
    func testInit() {
        
        let weatherLogic = WeatherViewModel()
        XCTAssertNotNil(weatherLogic)
        XCTAssertNotNil(weatherLogic.locationManager)
    }
    
    func testPlaceForLocation() {
        
        let weatherLogic = WeatherViewModel()
        let expectation = expectationWithDescription("Asynchronous call for current place name expectation")
        let govLocation = CLLocation.init(latitude: 51.5034070, longitude: -0.1275920)
        
        weatherLogic.place(govLocation) { (name) in
            
            XCTAssertNotNil(name)
            XCTAssertEqual(name, "London")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(5.0, handler:nil)
    }
}
