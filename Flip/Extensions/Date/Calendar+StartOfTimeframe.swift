//
//  Calendar+StartOfTimeframe.swift
//  Flip
//
//  Created by Jesal Patel on 7/29/22.
//

import Foundation

extension Calendar {
    func startOfYear(for date: Date) -> Date {
        let comp = Calendar.current.dateComponents([.year], from: date)
        let startOfYear = Calendar.current.date(from: comp) ?? Date.now
        return startOfYear
    }

    func startOfNextYear(for date: Date) -> Date {
        let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: date) ?? Date.distantFuture
        print(nextYear)
        return Calendar.current.startOfYear(for: nextYear)
    }

    func startOfMonth(for date: Date) -> Date {
        let comp = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = Calendar.current.date(from: comp) ?? Date.now
        return startOfMonth
    }
}
