//
//  BookTest.swift
//  FlipTests
//
//

import CoreData
import XCTest
@testable import Flip

class BookTest: BaseTestCase {
    func testCreatingBooks() {
        let targetCount = 10

        for _ in 0..<targetCount {
            _ = Book(context: managedObjectContext)
        }

        XCTAssertEqual(dataController.count(for: Book.fetchRequest()), targetCount)
    }

    func testDeletingSpecificBook() throws {
        try dataController.createSampleData()
        let request = NSFetchRequest<Book>(entityName: "Book")
        let books = try managedObjectContext.fetch(request)

        dataController.delete(books[0])
        XCTAssertEqual(dataController.count(for: Book.fetchRequest()), 12)
        dataController.delete(books[1])
        XCTAssertEqual(dataController.count(for: Book.fetchRequest()), 11)
    }
}
