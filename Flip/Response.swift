//
//  Response.swift
//  Flip
//
//  Created by Jesal Patel on 7/15/22.
//

import Foundation

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
    let publishedData: Date?
    let description: String?
    
    let pageCount: Int?
    let categories: [String]?
    let averageRatings: Int?
    let ratingsCount: Int?
    let imageLinks: ImageLinks?
    
}

struct ImageLinks: Codable {
    let smallThumbnail: URL?
    let thumbnail: URL?
}
