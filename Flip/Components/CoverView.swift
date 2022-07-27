//
//  CoverView.swift
//  Flip
//
//  Created by Jesal Patel on 7/17/22.
//

import SwiftUI
import NukeUI

// Downgraded from Nuke 11 -> Nuke 10 + NukeUI because Nuke 11 has a bug where
// ImageDecoding throws an error when decoding certain images while this doesn't
// happen on Nuke 10. Nuke 11 is only a couple days old at the time of using so
// periodically check if Nuke 11 will work as expected.

struct CoverView: View {
    let url: String

    init(url: URL?) {
        self.url = url?.absoluteString ?? ""
    }

    var body: some View {
        LazyImage(source: url) { state in
            if let image = state.image {
                image
            } else {
                Image(systemName: "book.closed")
                    .resizable()
                    .font(.body.weight(.ultraLight))
                    .scaledToFit()
            }
        }
    }
}

struct CoverView_Previews: PreviewProvider {
    static var previews: some View {
        CoverView(url: URL(string: "https://m.media-amazon.com/images/I/71SWhuF-O-L.jpg"))
    }
}
