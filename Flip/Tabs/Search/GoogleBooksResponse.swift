//
//  Response.swift
//  Flip
//
//  Created by Jesal Patel on 7/15/22.
//

import SwiftUI

struct GoogleBooksResponse: Codable {
    let totalItems: Int
    let items: [GoogleBook]?
}

struct GoogleBook: Codable, Identifiable, Hashable {
    let id: String
    let selfLink: String
    let volumeInfo: VolumeInfo

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func saveBook(dataController: DataController) {
        let managedObjectContext = dataController.container.viewContext
        let book = Book(context: managedObjectContext)
        book.id = self.id
        book.title = self.volumeInfo.wrappedTitle
        let authors = self.volumeInfo.wrappedAuthors.joined(separator: ", ")
        book.author = authors

        book.summary = self.volumeInfo.wrappedDescription
        book.read = false
        book.publicationDate = self.volumeInfo.wrappedPublishedDate
        let genres = self.volumeInfo.wrappedGenres.joined(separator: ", ")
        book.genres = genres
        book.publishingCompany = self.volumeInfo.wrappedPublisher
        book.pageCount = Int16(self.volumeInfo.wrappedPageCount)
        book.rating = Int16(3)
        book.dateRead = Date.distantFuture
        book.selfLink = self.selfLink
        book.thumbnail = self.volumeInfo.wrappedSmallThumbnail
        let identifiers = self.volumeInfo.industryIdentifiers ?? []
        for industryIdentifier in identifiers {
            if let isbn = industryIdentifier.type, let identifier = industryIdentifier.identifier {
                if isbn == "ISBN_10" {
                    book.isbn10 = identifier
                } else if isbn == "ISBN_13" {
                    book.isbn13 = identifier
                }
            }
        }
        // When adding the spotlight information for a book that isn't
        // initially in our library we need to save it first, before we
        // perform the dataController.update(book) function which adds
        // the spotlight information (and saves again) because book doesn't
        // initially have a unique objectId assigned to it by CoreData. Saving
        // before we update the spotlight information fixes this.
        dataController.save()
        dataController.update(book)
    }

    static var example: GoogleBook {
        GoogleBook(
            id: "abc123",
            selfLink: "somestring",
            volumeInfo:
                VolumeInfo(
                    title: "The Way of Kings",
                    subtitle: "Some Subtitle",
                    authors: ["Brandon Sanderson"],
                    publisher: "Random House",
                    publishedDate: "2022-01-01",
                    description: "This is a description, I don't know what the book is about.",
                    pageCount: 1403,
                    categories: ["Fiction", "Sci-Fi"],
                    imageLinks:
                        ImageLinks(
                            smallThumbnail: "",
                            thumbnail: ""),
                    industryIdentifiers: [IndustryIdentifier(type: "ISBN_10", identifier: "193906533X")]
                )
        )
    }

    static func == (lhs: GoogleBook, rhs: GoogleBook) -> Bool {
        return lhs.id == rhs.id
    }
}

struct VolumeInfo: Codable {
    let title: String?
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    // Not currently parsing publishedDate into a Date? because Google Books doesn't
    // always return a consistent date format. I've seen the format "yyyy" as
    // well as "yyyy-MM-dd" so far, but there may be others.
    let publishedDate: String?
    let description: String?

    let pageCount: Int?
    let categories: [String]?
    let imageLinks: ImageLinks?
    let industryIdentifiers: [IndustryIdentifier]?

    var wrappedTitle: String {
        title ?? "Unknown Title"
    }
    var wrappedSubtitle: String {
        subtitle ?? ""
    }
    var wrappedAuthors: [String] {
        authors ?? ["Unknown Author"]
    }
    var wrappedFirstAuthor: String {
        wrappedAuthors[0]
    }
    var wrappedPublisher: String {
        publisher ?? "Unknown Publisher"
    }
    var wrappedPublishedDate: String {
        publishedDate ?? "Unknown Publication Date"
    }
    var wrappedDescription: String {
        description ?? "No description"
    }
    var wrappedPageCount: Int {
        pageCount ?? 0
    }
    var wrappedGenres: [String] {
        categories ?? ["Unknown Genres"]
    }
    var wrappedSmallThumbnail: URL? {
        if let thumbnail = imageLinks?.httpsSmallThumbbnail {
            return URL(string: thumbnail)
        }
        return nil
    }
    var wrappedThumbnail: URL? {
        if let thumbnail = imageLinks?.httpsThumbnail {
            return URL(string: thumbnail)
        }
        return nil
    }

    static var example: VolumeInfo {
        let volumeInfo = VolumeInfo(
            title: "The Way of Kings",
            subtitle: "Some Subtitle",
            authors: ["Brandon Sanderson"],
            publisher: "Random House",
            publishedDate: "2022-01-01",
            description: "This is a description, I don't know what the book is about.",
            pageCount: 1403,
            categories: ["Fiction", "Sci-Fi"],
            imageLinks: ImageLinks(smallThumbnail: "", thumbnail: ""),
            industryIdentifiers: [
                IndustryIdentifier(type: "ISBN_10", identifier: "193906533X"),
                IndustryIdentifier(type: "ISBN_13", identifier: "9781939065339")
            ])
        return volumeInfo
    }
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?

    var httpsSmallThumbbnail: String? {
        if let smallThumbnail = smallThumbnail {
            return "https" + smallThumbnail.dropFirst(4)
        }
        return nil
    }
    var httpsThumbnail: String? {
        if let thumbnail = thumbnail {
            let upscaledString = thumbnail.replacingOccurrences(of: "zoom=1", with: "zoom=3")
            return "https" + upscaledString.dropFirst(4)
        }
        return nil
    }
}

struct IndustryIdentifier: Codable {
    let type: String?
    let identifier: String?
}
