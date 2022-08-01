//
//  DateFormatterTests.swift
//  FlipTests
//
//  Created by Jesal Patel on 8/1/22.
//

import XCTest
@testable import Flip

final class DateFormatterTests: XCTestCase {

    func testGettingDateFromFullFormat() {
        let formatter = DateFormatter()

        let date = "1997-06-22"
        let parsedDate = formatter.dateFromMultipleFormats(from: date)

        var dateComponents = DateComponents()
        dateComponents.year = 1997
        dateComponents.month = 6
        dateComponents.day = 22
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let actualDate = Calendar(identifier: .gregorian).date(from: dateComponents)

        XCTAssertEqual(parsedDate, actualDate)
    }

    func testGettingDateFromMediumFormat() {
        let formatter = DateFormatter()

        let date = "1997-06"
        let parsedDate = formatter.dateFromMultipleFormats(from: date)

        var dateComponents = DateComponents()
        dateComponents.year = 1997
        dateComponents.month = 6
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let actualDate = Calendar(identifier: .gregorian).date(from: dateComponents)

        XCTAssertEqual(parsedDate, actualDate)
    }

    func testGettingDateFromSmallFormat() {
        let formatter = DateFormatter()

        let date = "1997"
        let parsedDate = formatter.dateFromMultipleFormats(from: date)

        var dateComponents = DateComponents()
        dateComponents.year = 1997
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let actualDate = Calendar(identifier: .gregorian).date(from: dateComponents)

        XCTAssertEqual(parsedDate, actualDate)
    }
}
