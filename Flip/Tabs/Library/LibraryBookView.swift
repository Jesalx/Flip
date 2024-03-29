//
//  LibraryBookView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct LibraryBookView: View {
    @ObservedObject var book: Book

    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) private var dismiss
    @AppStorage("defaultRating") var defaultRating = 0

    @FetchRequest private var books: FetchedResults<Book>

    @State private var dateRead: Date
    @State private var read: Bool
    @State private var rating: Int
    @State private var showingDeleteConfirmation = false
    @State private var showingFullDescription = false
    @State private var showingEditMode = false

    init(book: Book) {
        self.book = book
        _dateRead = State(wrappedValue: book.bookDateRead)
        _read = State(wrappedValue: book.bookRead)
        _rating = State(wrappedValue: book.bookRating)

        let predicate = NSPredicate(format: "id == %@", book.bookId)
        let fetchRequest = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [], predicate: predicate)
        _books = fetchRequest
    }

    var optionalReadForm: some View {
        read ? readForm : nil
    }

    var readForm: some View {
        Group {
            HStack {
                Text("Rating")
                Spacer()
                LibraryRatingView(rating: $rating)
            }
            DatePicker("Date Finished", selection: $dateRead, in: ...Date.now, displayedComponents: [.date])
        }
    }

    var toolbarMenu: some View {
        Menu {
            // Sharelink doesn't work in this menu right now. Find out why
            // ShareLink(item: book.copyText)
            Button(action: book.copyToClipboard) {
                Label("Copy", systemImage: "doc.on.doc")
            }
            Button { showingEditMode = true } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button(role: .destructive) { showingDeleteConfirmation = true } label: {
                Label("Delete", systemImage: "trash")
            }
        } label: {
            Label("Book Options", systemImage: "ellipsis.circle")
        }
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    var body: some View {
        Form {
            HStack(alignment: .center) {
                CoverView(url: book.bookThumbnail)
                .cornerRadius(20)
                .frame(width: 190, height: 270)
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0)
            )

            Section("Author") {
                ForEach(book.bookAuthors, id: \.self) { author in
                    Text(author)
                }
            }
            Section("Publisher") {
                Text(book.bookPublisher)
            }
            Section("Publication Date") {
                Text(book.bookPublicationDate)
            }
            Section("Page Count") {
                Text("\(book.bookPageCount)")
            }
            Section("Genres") {
                ForEach(book.bookGenres, id: \.self) { genre in
                    Text(genre)
                }
            }
            Section("Description") {
                Text(book.bookSummary)
                    .lineLimit(showingFullDescription ? 100 : 8)
                    .onTapGesture {
                        showingFullDescription.toggle()
                    }
            }
            Section {
                Toggle("Mark Read", isOn: $read.animation())
                    .tint(.accentColor)
                optionalReadForm
            }
            Section {
                Button("Remove from library") {
                    showingDeleteConfirmation.toggle()
                }
                .tint(.red)
            }
        }
        .navigationTitle(book.bookTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: read) { _ in update() }
        .onChange(of: dateRead) { _ in update() }
        .onChange(of: rating) { _ in update() }
        .onDisappear { dataController.update(book) }
        .onAppear(perform: checkExists)
        .confirmationDialog("Delete Book", isPresented: $showingDeleteConfirmation) {
            Button("Delete Book", role: .destructive) { delete() }
        } message: {
            Text("Are you sure you want to delete \(book.bookTitle) from your library? This action cannot be undone.")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarMenu
            }
        }
        .sheet(isPresented: $showingEditMode) {
            NavigationView {
                LibraryBookEditView(book: book)
                    .presentationDetents([.large])
            }
        }
    }

    func update() {
        book.objectWillChange.send()
        book.read = read
        book.rating = Int16(rating)
        book.dateRead = formattedDate(dateRead)
        if read == false {
            book.dateRead = Date.distantFuture
            book.rating = Int16(defaultRating)
        }
        dataController.update(book)
    }

    func delete() {
        dataController.delete(book)
        dataController.save()
        dismiss()
    }

    func formattedDate(_ selectedDate: Date) -> Date {
        // Adds seconds and minutes to the given date from the picker so
        // that finished reading date sorting works as expected
        var comp = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        let now = Calendar.current.dateComponents([.hour, .minute, .second], from: Date.now)
        comp.hour = now.hour
        comp.minute = now.minute
        comp.second = now.second
        let constructedDate = Calendar.current.date(from: comp) ?? Date.now
        return min(constructedDate, Date.now)
    }

    func checkExists() {
        // We have to check if this book still exists in the situation:
        // User opens 'book1' in library. User navigates to Search tab.
        // User find 'book1' through search. User deletes 'book1' from
        // search tab. User switches to library tab. Adding this line them
        // out they are no longer left viewing a book that doesn't exist in
        // their library
        if books.first != nil { return }
        dismiss()
    }
}

struct LibraryBookView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        NavigationStack {
            LibraryBookView(book: Book.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
