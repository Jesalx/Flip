//
//  GoodreadsBook.swift
//  Flip
//
//  Created by Jesal Patel on 7/23/22.
//

import Foundation

struct GoodreadsBook {
    let goodreadsId: String
    let title: String
    let author: String
    let authorRev: String
    let additionalAuthors: String
    let isbn10: String
    let isbn13: String
    let userRating: String
    let avgRating: String
    let publishingCompany: String
    let binding: String
    let pageCount: String
    let publicationYear: String
    let origPublicationYear: String
    let dateRead: String
    let dateAdded: String
    let shelf: String
    let shelfPos: String
    let exclShelf: String
    let review: String
    let spoiler: String
    let privateNotes: String
    let readCount: String
    let recommendedFor: String
    let recommendedBy: String
    let ownedCopies: String
    let purchaseDate: String
    let purchaseLocation: String
    let condition: String
    let conditionDescription: String
    let bcid: String

    init?(row: [String]) {
        guard row.count == 31 else { return nil }
        self.goodreadsId = GoodreadsBook.cleanedRowString(rowString: row[0])
        self.title = GoodreadsBook.cleanedRowString(rowString: row[1])
        self.author = GoodreadsBook.cleanedRowString(rowString: row[2])
        self.authorRev = GoodreadsBook.cleanedRowString(rowString: row[3])
        self.additionalAuthors = GoodreadsBook.cleanedRowString(rowString: row[4])

        let isbn10 = GoodreadsBook.cleanedRowString(rowString: row[5])
        self.isbn10 = isbn10
            .filter { $0.isLetter || $0.isNumber }

        let isbn13 = GoodreadsBook.cleanedRowString(rowString: row[6])
        self.isbn13 = isbn13
            .filter { $0.isLetter || $0.isNumber }

        self.userRating = GoodreadsBook.cleanedRowString(rowString: row[7])
        self.avgRating = GoodreadsBook.cleanedRowString(rowString: row[8])
        self.publishingCompany = GoodreadsBook.cleanedRowString(rowString: row[9])
        self.binding = GoodreadsBook.cleanedRowString(rowString: row[10])
        self.pageCount = GoodreadsBook.cleanedRowString(rowString: row[11])
        self.publicationYear = GoodreadsBook.cleanedRowString(rowString: row[12])
        self.origPublicationYear = GoodreadsBook.cleanedRowString(rowString: row[13])
        self.dateRead = GoodreadsBook.cleanedRowString(rowString: row[14])
        self.dateAdded = GoodreadsBook.cleanedRowString(rowString: row[15])
        self.shelf = GoodreadsBook.cleanedRowString(rowString: row[16])
        self.shelfPos = GoodreadsBook.cleanedRowString(rowString: row[17])
        self.exclShelf = GoodreadsBook.cleanedRowString(rowString: row[18])
        self.review = GoodreadsBook.cleanedRowString(rowString: row[19])
        self.spoiler = GoodreadsBook.cleanedRowString(rowString: row[20])
        self.privateNotes = GoodreadsBook.cleanedRowString(rowString: row[21])
        self.readCount = GoodreadsBook.cleanedRowString(rowString: row[22])
        self.recommendedFor = GoodreadsBook.cleanedRowString(rowString: row[23])
        self.recommendedBy = GoodreadsBook.cleanedRowString(rowString: row[24])
        self.ownedCopies = GoodreadsBook.cleanedRowString(rowString: row[25])
        self.purchaseDate = GoodreadsBook.cleanedRowString(rowString: row[26])
        self.purchaseLocation = GoodreadsBook.cleanedRowString(rowString: row[27])
        self.condition = GoodreadsBook.cleanedRowString(rowString: row[28])
        self.conditionDescription = GoodreadsBook.cleanedRowString(rowString: row[29])
        self.bcid = GoodreadsBook.cleanedRowString(rowString: row[30])
    }

    func isValid(_ onlyValidDates: Bool) -> Bool {
        let isRead = Int(self.readCount) ?? 0 > 0 ? true : false
        if onlyValidDates && isRead && self.dateRead.isEmpty { return false }
        return (
            !self.title.isEmpty &&
            !self.author.isEmpty &&
            self.title != "NOT A BOOK" &&
            (!self.isbn10.isEmpty || !self.isbn13.isEmpty)
        )
    }

    func saveGoodreadsBook(dataController: DataController, onlyValidDates: Bool, overwriteDuplicates: Bool) -> Int {
        guard self.isValid(onlyValidDates) else { return 0 }
        guard overwriteDuplicates == true || !dataController.containsBook(id: self.goodreadsId) else { return 0 }

        let managedObjectContext = dataController.container.viewContext
        let book = dataController.book(id: self.goodreadsId) ?? Book(context: managedObjectContext)

        book.id = self.goodreadsId
        book.title = self.title
        var authors = self.author
        if !self.additionalAuthors.isEmpty {
            authors = self.author + ", " + self.additionalAuthors
        }
        book.author = authors

        let readCount = Int(self.readCount) ?? 0
        book.read = readCount > 0 ? true : false

        // If publication date doesn't exist, choose original publication date, if that doesn't exist
        // choose nil
        if !self.publicationYear.isEmpty {
            book.publicationDate = DateFormatter().dateFromMultipleFormats(from: self.publicationYear)
        } else if !self.origPublicationYear.isEmpty {
            book.publicationDate = DateFormatter().dateFromMultipleFormats(from: self.origPublicationYear)
        } else {
            book.publicationDate = nil
        }

        book.publishingCompany = self.publishingCompany.isEmpty ? nil : self.publishingCompany
        book.pageCount = Int16(self.pageCount) ?? Int16(0)
        book.rating = Int16(self.userRating) ?? Int16(0)

        if book.read {
            book.dateRead = strToDate(date: self.dateRead)
        }
        book.isbn10 = self.isbn10.isEmpty ? nil : self.isbn10
        book.isbn13 = self.isbn13.isEmpty ? nil : self.isbn13

        dataController.save()
        dataController.update(book)
        return 1
    }

    func strToDate(date: String) -> Date? {
        guard !date.isEmpty else { return Date.now }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }

    static func cleanedRowString(rowString: String) -> String {
        return rowString
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
