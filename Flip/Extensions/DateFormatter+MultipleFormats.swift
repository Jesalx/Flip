//
//  DateFormatter+MultipleFormats.swift
//  Flip
//
//  Created by Jesal Patel on 7/27/22.
//

import Foundation

extension DateFormatter {

    static let bookDateFormats: [String] = [
        "yyyy-MM-dd",
        "yyyy-MM",
        "yyyy"
    ]

    func dateFromMultipleFormats(from dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        if let date = ISO8601DateFormatter().date(from: dateString) { return date }
        for format in DateFormatter.bookDateFormats {
            self.dateFormat = format
            if let date = self.date(from: dateString) { return date }
        }
        return nil
    }
}
