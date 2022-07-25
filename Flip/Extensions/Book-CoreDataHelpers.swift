//
//  Book-CoreDataHelpers.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import Foundation

extension Book {
    enum SortOrder: String, Codable, CaseIterable {
        case title, author, pageCount, publicationDate, readDate
    }

    enum BookFilter: String, Codable, CaseIterable {
        case allBooks, readBooks, unreadBooks, unratedBooks
    }

    var bookId: String {
        id ?? "NO-ID-ERROR"
    }

    var bookTitle: String {
        title ?? "Unknown Title"
    }

    var bookAuthor: String {
        author ?? "Unknown Author"
    }

    var bookAuthors: [String] {
        let authors = bookAuthor.components(separatedBy: ", ")
        return authors
    }

    var bookFirstAuthor: String {
        bookAuthors.first ?? "Unknown Author"
    }

    var bookSummary: String {
        summary ?? "No Description."
    }

    var bookDateRead: Date {
        dateRead ?? Date.now
    }

    var bookPublicationDate: String {
        publicationDate ?? "Unknown Publication Date"
    }

    var bookRead: Bool {
        read
    }

    var bookPageCount: Int {
        Int(pageCount)
    }

    var bookRating: Int {
        Int(rating)
    }

    var bookPublisher: String {
        publishingCompany ?? "Unknown Publisher"
    }

    var googleURL: URL? {
        if let link = selfLink {
            return URL(string: link)
        }
        return nil
    }

    var bookGenres: [String] {
        guard let genreString = genres else { return ["No listed genres"] }
        let genreList: [String] = genreString.components(separatedBy: ",")
        let trimmed = genreList.map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        return trimmed
    }

    var bookThumbnail: URL? {
        if thumbnail != nil { return thumbnail }
        if let isbn13 = isbn13 { return Book.openLibraryUrl(isbn: isbn13) }
        if let isbn10 = isbn10 { return Book.openLibraryUrl(isbn: isbn10) }
        return nil
    }

    var weekDayNumber: Int {
        // Calendar will return an integer in range [1,7] while we need to use
        // integers in the range [0,6] for mapping to weekday names in
        // Calendar.weekdaySymbols so we'll subtract 1 from any result
        return Calendar.current.component(.weekday, from: bookDateRead) - 1
    }

    var monthNumber: Int {
        return Calendar.current.component(.month, from: bookDateRead) - 1
    }
    
    var copyText: String {
        bookTitle + " by " + bookAuthor
    }

    static var example: Book {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let book = Book(context: viewContext)
        book.id = "example-id-ABC123abc"
        book.title = "Example Title"
        book.author = "First Middle Last"
        book.summary = """
                    This is a summary of the book.
                    I don't know how long this will be for a real book,
                    but this will have to do for now. Example text.
                    """
        book.publicationDate = "2022"
        book.read = true
        book.dateRead = Date.now
        book.pageCount = Int16(Int.random(in: 20...1500))
        book.publishingCompany = "Random Publishing Company"
        book.genres = "Genre1, Genre2, Genre3"
        book.thumbnail = URL(string: "https://www.google.com")
        book.rating = Int16(Int.random(in: 1...5))

        return book
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

    static func openLibraryUrl(isbn: String) -> URL? {
        let urlString = "https://covers.openlibrary.org/b/isbn/\(isbn)-M.jpg?default=false"
        return URL(string: urlString)
    }
}
