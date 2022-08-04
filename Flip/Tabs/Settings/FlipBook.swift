//
//  FlipBook.swift
//  Flip
//
//  Created by Jesal Patel on 7/25/22.
//

import Foundation

struct FlipBook: Identifiable {
    let id: String
    let title: String?
    let author: String?
    let publishingCompany: String?
    let publicationDate: Date?
    let genres: String?
    let read: Bool
    let dateRead: Date?
    let isbn10: String?
    let isbn13: String?
    let pageCount: Int
    let rating: Int
    let thumbnail: URL?
    let summary: String?

    init(book: Book) {
        self.id = book.bookId
        self.title = book.title
        self.author = book.author
        self.publishingCompany = book.publishingCompany
        self.publicationDate = book.publicationDate
        self.genres = book.genres
        self.read = book.read
        self.dateRead = book.bookDateRead
        self.isbn10 = book.isbn10
        self.isbn13 = book.isbn13
        self.pageCount = book.bookPageCount
        self.rating = book.bookRating
        self.thumbnail = book.thumbnail
        self.summary = book.summary
    }

    init?(row: [String]) {
        guard row.count == 14 else { return nil }

        self.id = row[0].isEmpty ? UUID().uuidString : row[0]
        self.title = row[1].isEmpty ? nil : row[1]
        self.author = row[2].isEmpty ? nil : row[2]
        self.publishingCompany = row[3].isEmpty ? nil : row[3]
        self.publicationDate = DateFormatter().dateFromMultipleFormats(from: row[4])
        self.isbn10 = row[5].isEmpty ? nil : row[5].filter { $0.isLetter || $0.isNumber }
        self.isbn13 = row[6].isEmpty ? nil : row[6].filter { $0.isLetter || $0.isNumber }
        self.rating = Int(row[7]) ?? 0
        self.read = Bool(row[8].lowercased()) ?? false
        self.dateRead = DateFormatter().dateFromMultipleFormats(from: row[9])
        self.pageCount = Int(row[10]) ?? 0
        self.thumbnail = URL(string: row[11])
        self.genres = row[12].isEmpty ? nil : row[12]
        self.summary = row[13].isEmpty ? nil : row[13]
    }

    func saveFlipBook(dataController: DataController) -> Int {
        guard !dataController.containsBook(id: self.id) else { return 0 }

        let managedObjectContext = dataController.container.viewContext
        let book = Book(context: managedObjectContext)

        book.id = self.id
        book.title = self.title
        book.author = self.author
        book.publishingCompany = self.publishingCompany
        book.publicationDate = self.publicationDate
        book.isbn10 = self.isbn10
        book.isbn13 = self.isbn13
        book.rating = Int16(self.rating)
        book.read = self.read
        book.dateRead = read ? self.dateRead : nil
        book.pageCount = Int16(self.pageCount)
        book.thumbnail = self.thumbnail
        book.genres = self.genres
        book.summary = self.summary

        dataController.save()
        dataController.update(book)
        return 1
    }

    func createCsvRow() -> String {
        let id = exportString(self.id)
        let title = exportString(self.title)
        let author = exportString(self.author)
        let publisher = exportString(self.publishingCompany)
        var publicationDate: String
        if let pubDate = self.publicationDate {
            publicationDate = ISO8601DateFormatter().string(from: pubDate)
        } else {
            publicationDate = ""
        }
        let isbn10 = exportString(self.isbn10)
        let isbn13 = exportString(self.isbn13)
        let read = self.read
        let dateFinished = read ? ISO8601DateFormatter().string(from: self.dateRead ?? Date.now) : ""
        let rating = read ? self.rating : 0
        let pageCount = self.pageCount
        let thumbnail = self.thumbnail != nil ? self.thumbnail!.absoluteString : ""
        let genres = exportString(self.genres)
        let summary = exportString(self.summary)

        // swiftlint:disable:next line_length
        let bookRow = "\(id),\"\(title)\",\"\(author)\",\"\(publisher)\",\(publicationDate),\(isbn10),\(isbn13),\(rating),\(read),\(dateFinished),\(pageCount),\(thumbnail),\"\(genres)\",\"\(summary)\""
        return bookRow
    }

    func exportString(_ str: String?) -> String {
        guard let str = str else { return "" }
        var cleanedString = str.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        cleanedString = cleanedString.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanedString.replace("\"", with: "'")
        return cleanedString
    }
}
