//
//  ImageCache.swift
//  Flip
//
//  Created by Jesal Patel on 7/18/22.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 32*1000*1000, diskCapacity: 128*1000*1000)
}
