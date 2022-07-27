//
//  Book-CoreDataHelpers.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import Foundation

extension Book {

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

    var bookPublicationDateSort: Date {
        // For sorting purposes, unknown publication dates will come last
        publicationDate ?? Date.distantFuture
    }

    var bookPublicationDate: String {
        if let date = publicationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
        return "Unknown Publication Date"
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

    var bookGenreString: String {
        bookGenres.joined(separator: ", ")
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
        book.publicationDate = Date.distantPast
        book.read = true
        book.dateRead = Date.now
        book.pageCount = Int16(Int.random(in: 20...1500))
        book.publishingCompany = "Random Publishing Company"
        book.genres = "Genre1, Genre2, Genre3"
        book.thumbnail = URL(string: "https://www.google.com")
        book.rating = Int16(Int.random(in: 1...5))

        return book
    }

    static func openLibraryUrl(isbn: String) -> URL? {
        let urlString = "https://covers.openlibrary.org/b/isbn/\(isbn)-M.jpg?default=false"
        return URL(string: urlString)
    }
}
