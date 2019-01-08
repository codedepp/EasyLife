import XCTest
import CoreData
@testable import EasyLife

final class DataManagerTests: XCTestCase {
    func testMigrations() {
        // prepare
        let bundle = Bundle(for: DataManagerTests.self)
        do {
            // tests
            var url = bundle.url(forResource: "EasyLife", withExtension: "sqlite")
            try _ = NSPersistentContainer.inMemory(at: url)

            url = bundle.url(forResource: "EasyLife 1.3.0", withExtension: "sqlite")
            try _ = NSPersistentContainer.inMemory(at: url)

            url = bundle.url(forResource: "EasyLife 1.5.0", withExtension: "sqlite")
            try _ = NSPersistentContainer.inMemory(at: url)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    // TODO: need?
//    func testInsert() {
//        // mocks
//        let dataManager = DataManager()
//        let container = NSPersistentContainer.test()
//
//        // prepare
//        dataManager.persistentContainer = container
//
//        // test
//        let item = dataManager.insert(entityClass: TodoItem.self, context: dataManager.mainContext)
//        XCTAssertNotNil(item)
//    }
//
//    func testCopy() {
//        // mocks
//        let dataManager = DataManager()
//        let container = NSPersistentContainer.test()
//
//        // prepare
//        dataManager.persistentContainer = container
//        let item = dataManager.insert(entityClass: TodoItem.self, context: dataManager.mainContext)!
//        item.name = "test"
//
//        // test
//        let copy = dataManager.copy(item, context: dataManager.mainContext) as? TodoItem
//        XCTAssertNotNil(item)
//        XCTAssertEqual(item.name, copy?.name)
//    }
//
//    func testDelete() {
//        // mocks
//        let exp = expectation(description: "navigationController.willShow(...)")
//        let dataManager = DataManager()
//        let container = NSPersistentContainer.test()
//
//        // prepare
//        dataManager.persistentContainer = container
//        let item = dataManager.insert(entityClass: TodoItem.self, context: dataManager.mainContext)!
//
//        // test
//        dataManager.delete(item, context: dataManager.mainContext)
//        dataManager.fetch(entityClass: TodoItem.self, context: dataManager.mainContext, success: { results in
//            XCTAssertEqual(results?.count, 0)
//            exp.fulfill()
//        })
//        waitForExpectations(timeout: 1.0) { (err: Error?) in
//            XCTAssertNil(err)
//        }
//    }
//
//    func testFetch() {
//        // mocks
//        let exp = expectation(description: "navigationController.willShow(...)")
//        let dataManager = DataManager()
//        let container = NSPersistentContainer.test()
//
//        // prepare
//        dataManager.persistentContainer = container
//        _ = dataManager.insert(entityClass: TodoItem.self, context: dataManager.mainContext)!
//
//        // test
//        dataManager.fetch(entityClass: TodoItem.self, context: dataManager.mainContext, success: { results in
//            XCTAssertEqual(results?.count, 1)
//            exp.fulfill()
//        })
//        waitForExpectations(timeout: 1.0) { (err: Error?) in
//            XCTAssertNil(err)
//        }
//    }
//
//    func testSave() {
//        // mocks
//        let exp = expectation(description: "navigationController.willShow(...)")
//        let dataManager = DataManager()
//        let container = NSPersistentContainer.test()
//
//        // prepare
//        dataManager.persistentContainer = container
//        _ = dataManager.insert(entityClass: TodoItem.self, context: dataManager.mainContext)!
//
//        // test
//        dataManager.save(context: dataManager.mainContext, success: {
//            exp.fulfill()
//        })
//        waitForExpectations(timeout: 1.0) { (err: Error?) in
//            XCTAssertNil(err)
//        }
//    }
}
