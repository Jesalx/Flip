//
//  DevelopmentTests.swift
//  FlipTests
//
//

import CoreData
import XCTest
@testable import Flip

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()
        XCTAssertEqual(dataController.count(for: Book.fetchRequest()), 13)
    }

    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData()
        dataController.deleteAll()
        XCTAssertEqual(dataController.count(for: Book.fetchRequest()), 0)
    }

    func testExampleBookIsRead() {
        let book = Book.example
        XCTAssertEqual(book.read, true)
    }

    func testExampleBookId() {
        let book = Book.example
        XCTAssertEqual(book.id, "example-id-ABC123abc")
    }

    func testExampleBookTitle() {
        let book = Book.example
        XCTAssertEqual(book.title, "Example Title")
    }

    func testExampleBookAuthor() {
        let book = Book.example
        XCTAssertEqual(book.author, "First Middle Last")
    }

    func testExampleBookGenres() {
        let book = Book.example
        XCTAssertEqual(book.genres, "Genre1, Genre2, Genre3")
    }

    func testExampleBookPublishingCompany() {
        let book = Book.example
        XCTAssertEqual(book.publishingCompany, "Random Publishing Company")
    }
}
