//
//  Book-CoreDataHelpers.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import Foundation

extension Book {
    enum SortOrder {
        case title, author, publicationDate, readDate
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
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let book = Book(context: viewContext)
        book.id = "f3j2kljF=f2jlkf32j-l"
        book.title = "Example Title"
        book.author = "First Middle Last"
        book.summary = "This is a summary of the book. I don't know how long this will be for a real book, but this will have to do for now. Example text."
        book.publicationDate = "2022"
        book.read = Bool.random()
        book.dateRead = Date()
        book.pageCount = Int16(Int.random(in: 20...1500))
        book.publishingCompany = "Random Publishing Company"
        book.genres = "Genre1, Genre2, Genre3"
        book.thumbnail = URL(string: "https://www.google.com")
        
        
        return book
    }
}
