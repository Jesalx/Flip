//
//  Book+Sharing.swift
//  Flip
//
//  Created by Jesal Patel on 7/27/22.
//

import Foundation
import UIKit

extension Book {
    func copyToClipboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.copyText
    }
}
