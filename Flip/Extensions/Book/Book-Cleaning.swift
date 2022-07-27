//
//  Book-Cleaning.swift
//  Flip
//
//  Created by Jesal Patel on 7/27/22.
//

import Foundation

extension Book {
    static func cleanedBookString(string: String) -> String? {
        guard !string.isEmpty else { return nil }
        var output = string
        output = output.trimmingCharacters(in: .whitespacesAndNewlines)

        return output
    }
}
