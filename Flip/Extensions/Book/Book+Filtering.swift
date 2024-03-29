//
//  Book+Filtering.swift
//  Flip
//
//  Created by Jesal Patel on 7/26/22.
//

import Foundation

extension Book {
    enum SortOrder {
        case title, author, rating, pageCount, publicationDate, readDate
    }

    enum BookFilter: Equatable, Hashable {
        case allBooks, readBooks, unreadBooks, ratedBooks, unratedBooks, yearlyBooks, monthlyBooks
        case specificYear(Int)
        case specificRating(Int)
    }

    static func getPredicate(_ bookFilter: BookFilter) -> NSPredicate {
        let readPredicate = NSPredicate(format: "read = true")
        var predicate: NSPredicate
        switch bookFilter {
        case .allBooks:
            predicate = NSPredicate(value: true)
        case .readBooks:
            predicate = readPredicate
        case .unreadBooks:
            predicate = NSPredicate(format: "read = false")
        case .ratedBooks:
            let ratedPredicate = NSPredicate(format: "rating != 0")
            predicate = NSCompoundPredicate(type: .and, subpredicates: [readPredicate, ratedPredicate])
        case .unratedBooks:
            let unratedPredicate = NSPredicate(format: "rating = 0")
            predicate = NSCompoundPredicate(type: .and, subpredicates: [readPredicate, unratedPredicate])
        case .yearlyBooks:
            let startOfYear = Calendar.current.startOfYear(for: Date.now)
            let yearPredicate = NSPredicate(format: "dateRead >= %@", startOfYear as NSDate)
            predicate = NSCompoundPredicate(type: .and, subpredicates: [readPredicate, yearPredicate])
        case .monthlyBooks:
            let startOfMonth = Calendar.current.startOfMonth(for: Date.now)
            let monthPredicate = NSPredicate(format: "dateRead >= %@", startOfMonth as NSDate)
            predicate = NSCompoundPredicate(type: .and, subpredicates: [readPredicate, monthPredicate])
        case let .specificYear(year):
            let date = DateFormatter().dateFromMultipleFormats(from: String(year)) ?? .now
            let startOfYear = Calendar.current.startOfYear(for: date)
            let startOfNextYear = Calendar.current.startOfNextYear(for: date)
            print("DATE: \(date), STARTOFYEAR: \(startOfYear), NEXTYEAR: \(startOfNextYear)")
            predicate = NSPredicate(
                format: "dateRead >= %@ AND dateRead < %@",
                startOfYear as NSDate,
                startOfNextYear as NSDate
            )
        case let .specificRating(rating):
            let ratingPredicate = NSPredicate(format: "rating == %d", rating)
            predicate = NSCompoundPredicate(type: .and, subpredicates: [readPredicate, ratingPredicate])
        }
        return predicate
    }

    static func getSort(_ sortOrder: SortOrder) -> [NSSortDescriptor] {
        var descriptor: [NSSortDescriptor]
        switch sortOrder {
        case .title:
            descriptor = [
                NSSortDescriptor(keyPath: \Book.title, ascending: true),
                NSSortDescriptor(keyPath: \Book.publicationDate, ascending: true)
            ]
        case .author:
            descriptor = [
                NSSortDescriptor(keyPath: \Book.author, ascending: true),
                NSSortDescriptor(keyPath: \Book.publicationDate, ascending: true)
            ]
        case .rating:
            descriptor = [
                NSSortDescriptor(keyPath: \Book.read, ascending: false),
                NSSortDescriptor(keyPath: \Book.rating, ascending: false),
                NSSortDescriptor(keyPath: \Book.author, ascending: true),
                NSSortDescriptor(keyPath: \Book.dateRead, ascending: true),
                NSSortDescriptor(keyPath: \Book.publicationDate, ascending: true)
            ]
        case .pageCount:
            descriptor = [
                NSSortDescriptor(keyPath: \Book.pageCount, ascending: true),
                NSSortDescriptor(keyPath: \Book.publicationDate, ascending: true)
            ]
        case .readDate:
            descriptor = [
                NSSortDescriptor(keyPath: \Book.read, ascending: false),
                NSSortDescriptor(keyPath: \Book.dateRead, ascending: true),
                NSSortDescriptor(keyPath: \Book.publicationDate, ascending: true)
            ]
        case .publicationDate:
            descriptor = [
                NSSortDescriptor(keyPath: \Book.publicationDate, ascending: true),
                NSSortDescriptor(keyPath: \Book.title, ascending: true)
            ]
        }
        return descriptor
    }
}
