//
//  Response.swift
//  Flip
//
//  Created by Jesal Patel on 7/15/22.
//

import SwiftUI

struct Response: Codable {
    let items: [Item]
}

struct Item: Codable, Identifiable {
    let id: String
    let selfLink: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String?
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    // For some reason I can't set the date type of publishedDate to 'Date?' or else it won't decode
    // properly even when i set the dateDecodingStrategy and formatter to use "yyyy-MM-dd". Come back
    // to this and found out why this is happening
    let publishedDate: String?
    let description: String?
    
    let pageCount: Int?
    let categories: [String]?
//    let averageRatings: Int?
//    let ratingsCount: Int?
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
//        let volumeInfo = VolumeInfo(title: "The Way of Kings", subtitle: "Some Subtitle", authors: ["Brandon Sanderson"], publisher: "Random House", publishedDate: "2022-01-01", description: "This is a description, I don't know what the book is about.", pageCount: 1403, categories: ["Fiction", "Sci-Fi"], imageLinks: ImageLinks(smallThumbnail: URL(string: "http://books.google.com/books/content?id=QVn-CgAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: URL(string: "http://books.google.com/books/content?id=QVn-CgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api")))
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
