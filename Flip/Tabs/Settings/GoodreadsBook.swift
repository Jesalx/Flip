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
        self.goodreadsId = row[0]
        self.title = row[1]
        self.author = row[2]
        self.authorRev = row[3]
        self.additionalAuthors = row[4]

        let isbn10 = row[5]
        self.isbn10 = isbn10.filter { $0.isLetter || $0.isNumber }

        let isbn13 = row[6]
        self.isbn13 = isbn13.filter { $0.isLetter || $0.isNumber }

        self.userRating = row[7]
        self.avgRating = row[8]
        self.publishingCompany = row[9]
        self.binding = row[10]
        self.pageCount = row[11]
        self.publicationYear = row[12]
        self.origPublicationYear = row[13]
        self.dateRead = row[14]
        self.dateAdded = row[15]
        self.shelf = row[16]
        self.shelfPos = row[17]
        self.exclShelf = row[18]
        self.review = row[19]
        self.spoiler = row[20]
        self.privateNotes = row[21]
        self.readCount = row[22]
        self.recommendedFor = row[23]
        self.recommendedBy = row[24]
        self.ownedCopies = row[25]
        self.purchaseDate = row[26]
        self.purchaseLocation = row[27]
        self.condition = row[28]
        self.conditionDescription = row[29]
        self.bcid = row[30]
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

    func saveGoodreadsBook(dataController: DataController, onlyValidDates: Bool = false) {
        guard self.isValid(onlyValidDates) else { return }
        guard !dataController.containsBook(id: self.goodreadsId) else { return }
        let managedObjectContext = dataController.container.viewContext
        let book = Book(context: managedObjectContext)

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
        book.publicationDate = self.publicationYear.isEmpty ? nil : self.publicationYear
        if book.publicationDate == nil {
            book.publicationDate = self.origPublicationYear.isEmpty ? nil : self.origPublicationYear
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
    }

    func strToDate(date: String) -> Date? {
        guard !date.isEmpty else { return Date.now }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }
}
