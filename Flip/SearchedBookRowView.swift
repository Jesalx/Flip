//
//  SearchedBookRowView.swift
//  Flip
//
//  Created by Jesal Patel on 7/15/22.
//

import SwiftUI

struct SearchedBookRowView: View {
    let item: Item
    
    var body: some View {
        NavigationLink(destination: SearchedBookView(item: item)) {
            HStack {
                AsyncImage(url: item.volumeInfo.wrappedSmallThumbnail) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "book.closed")
                            .resizable()
                            .scaledToFit()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure(_):
                        Image(systemName: "book.closed")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        Image(systemName: "book.closed")
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 45, height: 70)
                .cornerRadius(8)
                VStack(alignment: .leading) {
                    Text(item.volumeInfo.wrappedTitle)
                        .font(.headline)
                    
                    Text(item.volumeInfo.wrappedFirstAuthor)
                        .font(.subheadline)
                }
            }
        }
    }
}

struct SearchedBookRowView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedBookRowView(item: Item.example)
    }
}
