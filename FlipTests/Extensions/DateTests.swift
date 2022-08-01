//
//  DateTests.swift
//  FlipTests
//
//  Created by Jesal Patel on 8/1/22.
//

import XCTest
@testable import Flip

final class DateTests: XCTestCase {

    func testGettingIntegerYearRegular() {
        var dateComponents = DateComponents()
        dateComponents.year = 1997
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 12
        dateComponents.minute = 15
        dateComponents.second = 30

        let date = Calendar(identifier: .gregorian).date(from: dateComponents) ?? Date.distantFuture

        XCTAssertEqual(date.year, 1997)
    }

    func testGettingIntegerDistantFutureYear() {
        var dateComponents = DateComponents()
        dateComponents.year = 4092
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let date = Calendar(identifier: .gregorian).date(from: dateComponents) ?? Date.distantPast

        XCTAssertEqual(date.year, 4092)
    }

    func testGettingIntegerDistantPastYear() {
        var dateComponents = DateComponents()
        dateComponents.year = 11
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let date = Calendar(identifier: .gregorian).date(from: dateComponents) ?? Date.distantFuture

        XCTAssertEqual(date.year, 11)
    }
}
