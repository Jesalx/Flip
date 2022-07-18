//
//  Book-CoreDataHelpers.swift
//  Flip
//
//

import Foundation

extension Book {
    enum SortOrder {
        case title, author, pageCount, publicationDate, readDate
    }

    enum BookFilter {
        case allBooks, readBooks, unreadBooks
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
        dateRead ?? Date()
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

    var wrappedRating: Int {
        Int(rating)
    }

    var bookPublisher: String {
        publishingCompany ?? "Unknown Publisher"
    }

    var bookGenres: [String] {
        guard let genreString = genres else { return ["No listed genres"] }
        let genreList: [String] = genreString.components(separatedBy: ",")
        let trimmed = genreList.map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        return trimmed
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
        book.dateRead = Date()
        book.pageCount = Int16(Int.random(in: 20...1500))
        book.publishingCompany = "Random Publishing Company"
        book.genres = "Genre1, Genre2, Genre3"
        book.thumbnail = URL(string: "https://www.google.com")
        book.rating = Int16(Int.random(in: 1...5))

        return book
    }
}
