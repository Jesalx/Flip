//
//  CoverView.swift
//  Flip
//
//  Created by Jesal Patel on 7/17/22.
//

import SwiftUI
import NukeUI

struct CoverView: View {
    let url: URL?

    var body: some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
            } else {
                Image(systemName: "book.closed")
                    .resizable()
                    .font(.body.weight(.ultraLight))
                    .scaledToFit()
            }
        }
        .pipeline(ImagePipeline.coverPipeline)
    }
}

struct CoverView_Previews: PreviewProvider {
    static var previews: some View {
        CoverView(url: URL(string: "https://m.media-amazon.com/images/I/71SWhuF-O-L.jpg"))
    }
}
