//
//  SearchedBookView.swift
//  Flip
//
//  Created by Jesal Patel on 7/15/22.
//

import SwiftUI

struct SearchedBookView: View {
    let item: Item
    
    var body: some View {
        List {
            HStack(alignment: .center) {
                AsyncImage(url: item.volumeInfo.wrappedSmallThumbnail) { phase in
                    switch phase {
                    case .empty:
//                        ProgressView()
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
                .cornerRadius(20)
                .frame(width: 190, height: 270)
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .listRowInsets( EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) )

            
            Section {
                Text(item.volumeInfo.wrappedTitle)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)

            
            Section("Author") {
                ForEach(item.volumeInfo.wrappedAuthors, id:\.self) { author in
                    Text(author)
                }
            }
            
            Section("Publisher") {
                Text(item.volumeInfo.wrappedPublisher)
            }
            
            Section("Publication Date") {
                Text(item.volumeInfo.wrappedPublishedDate)
            }
            
            Section("Page Count") {
                Text("\(item.volumeInfo.wrappedPageCount)")
            }
            
            Section("Genres") {
                ForEach(item.volumeInfo.wrappedGenres, id:\.self) { genre in
                    Text(genre)
                }
            }
            
            Section("Description") {
                Text(item.volumeInfo.wrappedDescription)
            }
        }
        .navigationTitle(item.volumeInfo.wrappedTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
           ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Label("Save", systemImage: "plus")
                        .font(.headline)
                }
            }
        }
    }
}

struct SearchedBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchedBookView(item: Item.example)
        }
    }
}
