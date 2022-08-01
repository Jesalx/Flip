//
//  CalendarTests.swift
//  FlipTests
//
//  Created by Jesal Patel on 8/1/22.
//

import XCTest
@testable import Flip

final class CalendarTests: XCTestCase {

    func testGettingStartOfRegularYear() {
        var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents) ?? Date.distantFuture

        dateComponents.year = 2022
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let expectedDate = calendar.date(from: dateComponents) ?? Date.distantPast

        XCTAssertEqual(calendar.startOfYear(for: date), expectedDate)
    }

    func testGettingStartOfRegularNextYear() {
        var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents) ?? Date.distantFuture

        dateComponents.year = 2023
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let expectedDate = calendar.date(from: dateComponents) ?? Date.distantPast

        XCTAssertEqual(calendar.startOfNextYear(for: date), expectedDate)
    }

    func testGettingStartOfRegularMonth() {
        var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 12
        dateComponents.minute = 15
        dateComponents.second = 30

        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents) ?? Date.distantFuture

        dateComponents.year = 2022
        dateComponents.month = 6
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let expectedDate = calendar.date(from: dateComponents) ?? Date.distantPast

        XCTAssertEqual(calendar.startOfMonth(for: date), expectedDate)
    }

    func testGettingStartOfDistantFutureYear() {
        var dateComponents = DateComponents()
        dateComponents.year = 4092
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents) ?? Date.distantFuture

        dateComponents.year = 4092
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let expectedDate = calendar.date(from: dateComponents) ?? Date.distantPast

        XCTAssertEqual(calendar.startOfYear(for: date), expectedDate)
    }

    func testGettingStartOfDistantFutureNextYear() {
        var dateComponents = DateComponents()
        dateComponents.year = 4092
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents) ?? Date.distantFuture

        dateComponents.year = 4093
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let expectedDate = calendar.date(from: dateComponents) ?? Date.distantPast

        XCTAssertEqual(calendar.startOfNextYear(for: date), expectedDate)
    }

    func testGettingStartOfDistantFutureMonth() {
        var dateComponents = DateComponents()
        dateComponents.year = 4092
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 12
        dateComponents.minute = 15
        dateComponents.second = 30

        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents) ?? Date.distantFuture

        dateComponents.year = 4092
        dateComponents.month = 6
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let expectedDate = calendar.date(from: dateComponents) ?? Date.distantPast

        XCTAssertEqual(calendar.startOfMonth(for: date), expectedDate)
    }

    func testGettingStartOfDistantPastYear() {
        var dateComponents = DateComponents()
        dateComponents.year = 12
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents) ?? Date.distantFuture

        dateComponents.year = 12
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let expectedDate = calendar.date(from: dateComponents) ?? Date.distantPast

        XCTAssertEqual(calendar.startOfYear(for: date), expectedDate)
    }

    func testGettingStartOfDistantPastNextYear() {
        var dateComponents = DateComponents()
        dateComponents.year = 12
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents) ?? Date.distantFuture

        dateComponents.year = 13
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let expectedDate = calendar.date(from: dateComponents) ?? Date.distantPast

        XCTAssertEqual(calendar.startOfNextYear(for: date), expectedDate)
    }

    func testGettingStartOfDistantPastMonth() {
        var dateComponents = DateComponents()
        dateComponents.year = 12
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 12
        dateComponents.minute = 15
        dateComponents.second = 30

        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents) ?? Date.distantFuture

        dateComponents.year = 12
        dateComponents.month = 6
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let expectedDate = calendar.date(from: dateComponents) ?? Date.distantPast

        XCTAssertEqual(calendar.startOfMonth(for: date), expectedDate)
    }

}
