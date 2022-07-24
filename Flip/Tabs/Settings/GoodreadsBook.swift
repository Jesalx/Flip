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

    init(line: [String]) {
        self.goodreadsId = line[0]
        self.title = line[1]
        self.author = line[2]
        self.authorRev = line[3]
        self.additionalAuthors = line[4]
        // =\"1505886554\"
        // =\"\"
        var isbn10 = line[5]
        isbn10.removeFirst(2)
        isbn10.removeLast(1)
        self.isbn10 = isbn10
        var isbn13 = line[6]
        isbn13.removeFirst(2)
        isbn13.removeLast(1)
        self.isbn13 = isbn13
        self.userRating = line[7]
        self.avgRating = line[8]
        self.publishingCompany = line[9]
        self.binding = line[10]
        self.pageCount = line[11]
        self.publicationYear = line[12]
        self.origPublicationYear = line[13]
        self.dateRead = line[14]
        self.dateAdded = line[15]
        self.shelf = line[16]
        self.shelfPos = line[17]
        self.exclShelf = line[18]
        self.review = line[19]
        self.spoiler = line[20]
        self.privateNotes = line[21]
        self.readCount = line[22]
        self.recommendedFor = line[23]
        self.recommendedBy = line[24]
        self.ownedCopies = line[25]
        self.purchaseDate = line[26]
        self.purchaseLocation = line[27]
        self.condition = line[28]
        self.conditionDescription = line[29]
        self.bcid = line[30]
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
        let managedObjectContext = dataController.container.viewContext
        let book = Book(context: managedObjectContext)

        book.id = UUID().uuidString
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
