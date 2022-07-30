//
//  Calendar+StartOfTimeframe.swift
//  Flip
//
//  Created by Jesal Patel on 7/29/22.
//

import Foundation

extension Calendar {
    func startOfYear(for date: Date) -> Date {
        let comp = Calendar.current.dateComponents([.year], from: Date.now)
        let startOfYear = Calendar.current.date(from: comp) ?? Date.now
        return startOfYear
    }

    func startOfMonth(for date: Date) -> Date {
        let comp = Calendar.current.dateComponents([.year, .month], from: Date.now)
        let startOfMonth = Calendar.current.date(from: comp) ?? Date.now
        return startOfMonth
    }
}
