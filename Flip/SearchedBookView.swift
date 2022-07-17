//
//  SearchedBookView.swift
//  Flip
//
//  Created by Jesal Patel on 7/15/22.
//

import SwiftUI

struct SearchedBookView: View {
    let item: Item
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest private var books: FetchedResults<Book>
    
    @State private var showingFullDescription = false
    @State private var showingDeleteConfirmation = false
    
    init(item: Item) {
        self.item = item
        let predicate = NSPredicate(format: "id == %@", item.id)
        let fetchRequest = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [], predicate: predicate)
        _books = fetchRequest
    }
    
    var body: some View {
        List {
            HStack(alignment: .center) {
                AsyncImage(url: item.volumeInfo.wrappedSmallThumbnail) { phase in
                    switch phase {
                    case .empty, .failure(_):
                        Image(systemName: "book.closed")
                            .resizable()
                            .scaledToFit()
                    case .success(let image):
                        image
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
                    .lineLimit(showingFullDescription ? 100 : 5)
                    .onTapGesture {
                        showingFullDescription.toggle()
                    }
            }
        }
        .navigationTitle(item.volumeInfo.wrappedTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: dataController.save)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if let _ = books.first {
                    Button(role: .destructive) {
                        showingDeleteConfirmation.toggle()
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                } else {
                    Button {
                        saveBook()
                    } label: {
                        Label("Save", systemImage: "plus.circle")
                            .font(.headline)
                    }
                }
            }
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(title: Text("Delete book"), message: Text("Are you sure you want to delete \(item.volumeInfo.wrappedTitle) from your library?"), primaryButton: .destructive(Text("Delete"), action: deleteBook), secondaryButton: .cancel())
        }
    }
    
    func saveBook() {
        if let _ = books.first { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let book = Book(context: managedObjectContext)
        book.id = item.id
        book.title = item.volumeInfo.wrappedTitle
        let authors = item.volumeInfo.wrappedAuthors.joined(separator: ", ")
        book.author = authors
        
        book.summary = item.volumeInfo.wrappedDescription
        book.read = false
        book.publicationDate = item.volumeInfo.wrappedPublishedDate
        let genres = item.volumeInfo.wrappedGenres.joined(separator: ", ")
        book.genres = genres
        book.publishingCompany = item.volumeInfo.wrappedPublisher
        book.pageCount = Int16(item.volumeInfo.wrappedPageCount)
        book.dateRead = Date()
        book.thumbnail = item.volumeInfo.wrappedSmallThumbnail
        dataController.save()
    }
    
    func deleteBook() {
        if let book = books.first {
            dataController.delete(book)
            dataController.save()
            return
        }
    }
}

struct SearchedBookView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        NavigationView {
            SearchedBookView(item: Item.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
