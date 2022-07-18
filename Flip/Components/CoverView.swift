//
//  CoverView.swift
//  Flip
//
//

import CachedAsyncImage
import SwiftUI

struct CoverView: View {
    let url: URL?

    var body: some View {
        CachedAsyncImage(url: url, urlCache: .imageCache) { phase in
            thumbnailImage(phase)
        }
    }

    func thumbnailImage(_ phase: AsyncImagePhase) -> some View {
        Group {
            switch phase {
            case .empty, .failure:
                Image(systemName: "book.closed")
                    .resizable()
                    .font(.body.weight(.ultraLight))
                    .scaledToFit()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            @unknown default:
                Image(systemName: "book.closed")
                    .resizable()
                    .font(.body.weight(.ultraLight))
                    .scaledToFit()
            }
        }
    }
}
