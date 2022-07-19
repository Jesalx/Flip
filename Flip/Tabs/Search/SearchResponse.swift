//
//  Response.swift
//  Flip
//
//

import SwiftUI

struct SearchResponse: Codable {
    let totalItems: Int
    let items: [Item]?
}

struct Item: Codable, Identifiable, Hashable {
    let id: String
    let selfLink: String
    let volumeInfo: VolumeInfo

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }

    static var example: Item {
        Item(
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
                            thumbnail: "")
                )
        )
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
            imageLinks: ImageLinks(smallThumbnail: "", thumbnail: ""))
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
