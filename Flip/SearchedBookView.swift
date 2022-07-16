//
//  SearchedBookView.swift
//  Flip
//
//  Created by Jesal Patel on 7/15/22.
//

import SwiftUI

struct SearchedBookView: View {
    let volumeInfo: VolumeInfo
    
    var body: some View {
        List {
            HStack(alignment: .center) {
                AsyncImage(url: volumeInfo.wrappedSmallThumbnail) { phase in
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
                Text(volumeInfo.wrappedTitle)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)

            
            Section("Author") {
                ForEach(volumeInfo.wrappedAuthors, id:\.self) { author in
                    Text(author)
                }
            }
            
            Section("Publisher") {
                Text(volumeInfo.wrappedPublisher)
            }
            
            Section("Publication Date") {
                Text(volumeInfo.wrappedPublishedDate)
            }
            
            Section("Page Count") {
                Text("\(volumeInfo.wrappedPageCount)")
            }
            
            Section("Genres") {
                ForEach(volumeInfo.wrappedGenres, id:\.self) { genre in
                    Text(genre)
                }
            }
            
            Section("Description") {
                Text(volumeInfo.wrappedDescription)
            }
        }
        .navigationTitle(volumeInfo.wrappedTitle)
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
            SearchedBookView(volumeInfo: VolumeInfo.example)
        }
    }
}
