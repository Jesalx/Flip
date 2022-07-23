//
//  SearchedBookView.swift
//  Flip
//
//  Created by Jesal Patel on 7/15/22.
//

import SwiftUI

struct SearchedBookView: View {
    let item: GoogleBook

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest private var books: FetchedResults<Book>

    @State private var showingFullDescription = false
    @State private var showingDeleteConfirmation = false

    init(item: GoogleBook) {
        self.item = item
        let predicate = NSPredicate(format: "id == %@", item.id)
        let fetchRequest = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [], predicate: predicate)
        _books = fetchRequest
    }

    var bookExists: Bool {
        guard books.first != nil else { return false }
        return true
    }

    var addDeleteToolbarItem: some View {
        if bookExists {
            return AnyView(Button(role: .destructive) {
                showingDeleteConfirmation.toggle()
            } label: {
                Label("Delete", systemImage: "trash")
                    .foregroundColor(.red)
            })
        } else {
            return AnyView(Button {
                saveBook()
            } label: {
                Label("Save", systemImage: "bookmark")
                    .font(.headline)
            })
        }
    }

    var body: some View {
        List {
            HStack(alignment: .center) {
                CoverView(url: item.volumeInfo.wrappedSmallThumbnail)
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
                ForEach(item.volumeInfo.wrappedAuthors, id: \.self) { author in
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
                ForEach(item.volumeInfo.wrappedGenres, id: \.self) { genre in
                    Text(genre)
                }
            }
            Section("Description") {
                Text(item.volumeInfo.wrappedDescription)
                    .lineLimit(showingFullDescription ? 100 : 7)
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
                addDeleteToolbarItem
            }
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Delete book"),
                message: Text("Are you sure you want to delete \(item.volumeInfo.wrappedTitle) from your library?"),
                primaryButton: .destructive(Text("Delete"), action: deleteBook),
                secondaryButton: .cancel())
        }
    }

    func saveBook() {
        if books.first != nil { return }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        item.saveGoogleBook(dataController: dataController)
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
        NavigationStack {
            SearchedBookView(item: GoogleBook.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
