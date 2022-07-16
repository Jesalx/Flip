//
//  DataController.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Flip")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
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
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...10 {
            let book = Book(context: viewContext)
            book.id = UUID().uuidString
            book.title = "Book \(i)"
            book.author = "Author Name"
            book.summary = "This is a summar of some book. Words. Blah blah blah."
            book.read = Bool.random()
            book.publicationDate = "2022"
            book.genres = "Genre1, Genre2, Genre3"
            book.publishingCompany = "Random House Publishing"
            book.pageCount = Int16.random(in: 1...1400)
            book.dateRead = Date()
        }
        let book = Book(context: viewContext)
        book.id = UUID().uuidString
        book.title = "The Way of Kings"
        book.author = "Brandon Sanderson"
        book.summary = """
        Roshar is a world of stone and storms. Uncanny tempests of incredible power sweep across the rocky terrain so frequently that they have shaped ecology and civilization alike. Animals hide in shells, trees pull in branches, and grass retracts into the soilless ground. Cities are built only where the topography offers shelter.
        """
        book.read = true
        book.publicationDate = "2021"
        book.genres = "Fantasy, Action & Adventure, Epic"
        book.publishingCompany = "Tom Doherty Associates, 2010"
        book.pageCount = Int16(1008)
        book.dateRead = Date()
        
        let book2 = Book(context: viewContext)
        book2.id = UUID().uuidString
        book2.title = "Reaper"
        book2.author = "Will Wight"
        book2.summary = """
        With his home finally secure, Lindon delves deep into the ancient labyrinth, seeking long-lost Soulsmithing knowledge and the secret to destroying the Dreadgods. Monarchs plot against him and against each other, unaware of the threats gathering in realms beyond.

        Far above Lindon and the Monarchs and the Dreadgods, another war is waged. Suriel and the Abidan clash against the Mad King and his forces in a battle for the fate of many worlds.

        And if it is lost, Cradle will be destroyed.
        """
        book2.read = true
        book2.publicationDate = "2012"
        book2.genres = "Fiction, Fantasy, General"
        book2.publishingCompany = "Hidden Gnome Publishing"
        book2.pageCount = Int16(442)
        book2.dateRead = Date()
        
        let book3 = Book(context: viewContext)
        book3.id = UUID().uuidString
        book3.title = "This is a really long title of a book that doesn't exist so I can see how it looks"
        book3.author = "Sir Noobington Richard Reginald Arthur"
        book3.summary = "This book takes place in space."
        book3.read = true
        book3.publicationDate = "2014"
        book3.genres = "Genre1, Genre2, Genre3"
        book3.publishingCompany = "Random House Publishing"
        book3.pageCount = 3600
        book3.dateRead = Date()
        
        try viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Book.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
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
}
