//
//  LibraryBookView.swift
//  Flip
//
//

import CachedAsyncImage
import SwiftUI

struct LibraryBookView: View {
    let book: Book

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var dateRead: Date
    @State private var read: Bool
    @State private var showingDeleteConfirmation = false
    @State private var showingFullDescription = false

    init(book: Book) {
        self.book = book
        _dateRead = State(wrappedValue: book.bookDateRead)
        _read = State(wrappedValue: book.bookRead)
    }

    var optionalDateView: some View {
        read
        ? DatePicker("Date Finished", selection: $dateRead, in: ...Date.now, displayedComponents: .date)
            .datePickerStyle(.graphical)
        : nil
    }

    var body: some View {
        List {
            HStack(alignment: .center) {
                CachedAsyncImage(url: book.thumbnail) { phase in
                    coverImage(phase)
                }
                .cornerRadius(20)
                .frame(width: 190, height: 270)
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .listRowInsets( EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) )

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
                Toggle("Mark Read", isOn: $read)
                optionalDateView

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
        .onChange(of: read) { _ in updateRead() }
        .onChange(of: dateRead) { _ in updateDate() }
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Delete book"),
                message: Text("Are you sure you want to delete \(book.bookTitle) from your library?"),
                primaryButton: .destructive(Text("Delete"), action: delete),
                secondaryButton: .cancel())
        }
    }

    func coverImage(_ phase: AsyncImagePhase) -> some View {
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

    func updateRead() {
        book.objectWillChange.send()
        book.read = read
        if read == false {
            book.dateRead = Date()
        }
        dataController.save()
    }

    func updateDate() {
        book.objectWillChange.send()
        book.dateRead = dateRead
        dataController.save()
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
