//
//  DataController.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import CoreData
import CoreSpotlight
import SwiftUI
import WidgetKit

/// A singleton responsible for managing Core Data, specifically handling saving
/// and loading, checking the existence of a book, and adding sample data for
/// debugging purposes
class DataController: ObservableObject {

    /// CloudKit container responsible for storing all book related data
    let container: NSPersistentCloudKitContainer

    /// Initializes data controller in memory for debugging and development purposes
    /// or on disk for regular application runs.
    /// - Parameter inMemory: Whether to store this data in temporary memory
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Flip", managedObjectModel: Self.model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let groupID = "group.dev.jesal.Flip"
            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appending(path: "Flip.sqlite")
            }
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }

        self.container.viewContext.automaticallyMergesChangesFromParent = true
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        return dataController
    }()

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Flip", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        return managedObjectModel
    }()

    /// Creates example books for testing purposes. Creates 13 Book objects in total.
    func createSampleData() throws {
        // swiftlint:disable:previous function_body_length
        let viewContext = container.viewContext

        for num in 1...10 {
            let book = Book(context: viewContext)
            book.id = UUID().uuidString
            book.title = "Book \(num)"
            book.author = "Author Name"
            book.summary = "This is a summary of some book. Words. Blah blah blah."
            book.read = Bool.random()
            book.publicationDate = Date.now
            book.rating = Int16(Int.random(in: 1...5))
            book.genres = "Genre1, Genre2, Genre3"
            book.publishingCompany = "Random House Publishing"
            book.pageCount = Int16.random(in: 1...1400)
            book.dateRead = Date()
            book.thumbnail = URL(string: "https://www.google.com")
        }
        let book = Book(context: viewContext)
        book.id = UUID().uuidString
        book.title = "The Way of Kings"
        book.author = "Brandon Sanderson"
        // swiftlint:disable:next line_length
        book.summary = "Roshar is a world of stone and storms. Uncanny tempests of incredible power sweep across the rocky terrain so frequently that they have shaped ecology and civilization alike. Animals hide in shells, trees pull in branches, and grass retracts into the soilless ground. Cities are built only where the topography offers shelter."
        book.read = true
        book.publicationDate = Date.now
        book.rating = Int16(Int.random(in: 1...5))
        book.genres = "Fantasy, Action & Adventure, Epic"
        book.publishingCompany = "Tom Doherty Associates, 2010"
        book.pageCount = Int16(1008)
        book.dateRead = Date()
        book.thumbnail = URL(string: "https://www.google.com")

        let book2 = Book(context: viewContext)
        book2.id = UUID().uuidString
        book2.title = "Reaper"
        book2.author = "Will Wight"
        // swiftlint:disable:next line_length
        book2.summary = "With his home finally secure, Lindon delves deep into the ancient labyrinth, seeking long-lost Soulsmithing knowledge and the secret to destroying the Dreadgods. Monarchs plot against him and against each other, unaware of the threats gathering in realms beyond. Far above Lindon and the Monarchs and the Dreadgods, another war is waged. Suriel and the Abidan clash against the Mad King and his forces in a battle for the fate of many worlds. And if it is lost, Cradle will be destroyed."
        book2.read = true
        book2.publicationDate = Date.now
        book2.rating = Int16(Int.random(in: 1...5))
        book2.genres = "Fiction, Fantasy, General"
        book2.publishingCompany = "Hidden Gnome Publishing"
        book2.pageCount = Int16(442)
        book2.dateRead = Date()
        book2.thumbnail = URL(string: "https://www.google.com")

        let book3 = Book(context: viewContext)
        book3.id = UUID().uuidString
        book3.title = "This is a really long title of a book that doesn't exist so I can see how it looks"
        book3.author = "Sir Noobington Richard Reginald Arthur"
        book3.summary = "This book takes place in space."
        book3.read = true
        book3.publicationDate = Date.now
        book3.rating = Int16(Int.random(in: 1...5))
        book3.genres = "Genre1, Genre2, Genre3"
        book3.publishingCompany = "Random House Publishing"
        book3.pageCount = 3600
        book3.dateRead = Date()
        book3.thumbnail = URL(string: "https://www.google.com")

        try viewContext.save()
    }

    /// Saves Core Data context if there are changes, but does nothing if there
    /// are no changes to be made.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    func delete(_ object: Book) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
//        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: ["dev.jesal"])
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Book.fetchRequest()
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: ["dev.jesal"])
        delete(fetchRequest)
    }

    func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func containsBook(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<Book> = NSFetchRequest(entityName: "Book")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let existence = count(for: fetchRequest)
        return existence >= 1
    }

    func update(_ book: Book) {
        let bookId = book.objectID.uriRepresentation().absoluteString
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = book.bookTitle
        attributeSet.authorNames = book.bookAuthors
        attributeSet.contentDescription = book.bookSummary

        let searchableItem = CSSearchableItem(
            uniqueIdentifier: bookId,
            domainIdentifier: "dev.jesal",
            attributeSet: attributeSet
        )

        CSSearchableIndex.default().indexSearchableItems([searchableItem])
        save()
    }

    func book(with uniqueIdentifier: String) -> Book? {
        guard let url = URL(string: uniqueIdentifier) else {
            return nil
        }

        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }

        return try? container.viewContext.existingObject(with: id) as? Book
    }

    func yearlyReadCount() -> Int {
        let request: NSFetchRequest<Book> = Book.fetchRequest()

        // For some reason this file doesn't believe that Calendar.current.startOfYear
        // exists even though there is an extension for it and other files in the app are
        // using it. Look into this when you have time.
        // let startOfYear = Calendar.current.startOfYear(for: Date.now)
        let comp = Calendar.current.dateComponents([.year], from: Date.now)
        let startOfYear = Calendar.current.date(from: comp) ?? Date.now
        let yearPredicate = NSPredicate(format: "dateRead >= %@", startOfYear as NSDate)
        let readPredicate = NSPredicate(format: "read = true")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [yearPredicate, readPredicate])

        request.predicate = compoundPredicate
        request.sortDescriptors = []

        if let books = try? container.viewContext.fetch(request) {
            return books.count
        }
        return 0
    }
}
