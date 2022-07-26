//
//  Book-Filtering.swift
//  Flip
//
//  Created by Jesal Patel on 7/26/22.
//

import Foundation

extension Book {
    enum SortOrder: String, Codable, CaseIterable {
        case title, author, pageCount, publicationDate, readDate
    }

    enum BookFilter: String, Codable, CaseIterable {
        case allBooks, readBooks, unreadBooks, unratedBooks
    }

    static func getPredicate(_ bookFilter: BookFilter) -> NSPredicate {
        var predicate: NSPredicate
        switch bookFilter {
        case .allBooks:
            predicate = NSPredicate(value: true)
        case .readBooks:
            predicate = NSPredicate(format: "read = true")
        case .unreadBooks:
            predicate = NSPredicate(format: "read = false")
        case .unratedBooks:
            predicate = NSPredicate(format: "read = true AND rating = 0")
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
