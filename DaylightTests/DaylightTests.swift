//
//  DaylightTests.swift
//  DaylightTests
//
//  Created by Ben Farmer on 5/6/21.
//

import XCTest
import CoreLocation
@testable import Daylight

class DaylightTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testDaylightTimeShift() {
        let viewModel = Daylight.ViewModel()
        let hourShift = globalHourShift
        let calendar = Calendar.current
        
        viewModel.update()
        let currentDate = Date().addingTimeInterval(Double(60 * 60 * hourShift))
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        let modelComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: viewModel.timeData.currentTime)
        
        XCTAssertEqual(components, modelComponents)
    }
}
