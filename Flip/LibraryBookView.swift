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
    
    @State private var dateRead: Date
    @State private var read: Bool
    
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
                Text(book.bookPublicationDate, style: .date)
            }
            
            Section {
                Toggle("Mark Read", isOn: $read)
                DatePicker("Date Finished", selection: $dateRead, in: ...Date.now, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
        }
        .navigationTitle(book.bookTitle)
//        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LibraryBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LibraryBookView(book: Book.example)
        }
    }
}
