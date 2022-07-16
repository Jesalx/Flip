//
//  LibraryBookView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct LibraryBookView: View {
    let book: Book
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var dateRead: Date
    @State private var read: Bool
    @State private var showingDeleteConfirmation = false
    
    init(book: Book) {
        self.book = book
        _dateRead = State(wrappedValue: book.bookDateRead)
        _read = State(wrappedValue: book.bookRead)
    }
    
    var body: some View {
        List {
            Section("Author") {
                Text(book.bookAuthor)
            }
            
            Section("Genres") {
                ForEach(book.bookGenres, id:\.self) { genre in
                    Text(genre)
                }
            }
            
            Section("Description") {
                Text(book.bookSummary)
            }
            
            Section("Page Count") {
                Text("\(book.pageCount)")
            }
            
            Section("Publisher") {
                Text(book.bookPublisher)
            }
            
            Section("Publication Date") {
                Text(book.bookPublicationDate)
            }
            
            Section {
                Toggle("Mark Read", isOn: $read)
                if read {
                    DatePicker("Date Finished", selection: $dateRead, in: ...Date.now, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
            }
            
            Section {
                Button("Remove from library") {
                    showingDeleteConfirmation.toggle()
                }
                    .tint(.red)
            }
        }
        .navigationTitle(book.bookTitle)
        .onChange(of: read) { _ in update() }
        .onChange(of: dateRead) { _ in update() }
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(title: Text("Delete book"), message: Text("Are you sure you want to delete \(book.bookTitle) from your library?"), primaryButton: .destructive(Text("Delete"), action: delete), secondaryButton: .cancel())
        }
    }
    
    func update() {
        book.objectWillChange.send()
        book.read = read
        book.dateRead = dateRead
    }
    
    func delete() {
        dataController.delete(book)
        presentationMode.wrappedValue.dismiss()
    }
}

struct LibraryBookView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        NavigationView {
            LibraryBookView(book: Book.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
