//
//  NSDateExtensionsTests.swift
//  Wipro
//
//  Created by Mladen Despotovic on 20/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import XCTest
@testable import Wipro

class NSDateExtensionsTests: XCTestCase {
    
    var baseDate:NSDate? = nil
    
    override func setUp() {
        
        super.setUp()
        baseDate = NSDate.init(timeIntervalSinceReferenceDate: 0)
    }
    
    override func tearDown() {
        
        baseDate = nil
        super.tearDown()
    }
    
    func testTimeString() {
        
        baseDate = NSDate.init(timeIntervalSinceReferenceDate: 3600)
        let timeString = baseDate?.timeString()
        XCTAssertEqual(timeString, "1:00 AM")
    }
    
    func testShortDateString() {
        
        baseDate = NSDate.init(timeIntervalSinceReferenceDate: 3600)
        let dateString = baseDate?.shortDateString()
        XCTAssertEqual(dateString, "01 Jan")
    }
    
}
