//
//  UserControllerTests.swift
//  CoreDataCodableTests
//
//  Created by Andrea Prearo on 4/2/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import XCTest
import CoreData
import OHHTTPStubs
import OHHTTPStubsSwift

@testable import CoreDataCodable

class UserControllerTests: XCTestCase {
    private static let defaultWait = 5.0
    private static let entityName = "User"

    var coreDataCodableTestingHelper: CoreDataCodableTestingHelper!
    var userController: UserController!

    override func setUp() {
        super.setUp()

        coreDataCodableTestingHelper = CoreDataCodableTestingHelper()
        coreDataCodableTestingHelper.clearStorage(for: UserControllerTests.entityName)

        userController = UserController(persistentContainer: coreDataCodableTestingHelper.mockPersistentContainer)

        stub { request in
            let url = request.url!
            return url.path.contains("users") && url.query == "id=1&count=100"
        } response: { _ in
            return self.coreDataCodableTestingHelper.stubResponse(for: "users.json", statusCode: 200)
        }

        stub { request in
            let url = request.url!
            return url.path.contains("users") && url.query != "id=1&count=100"
        } response: { _ in
            return HTTPStubsResponse(data: Data([]), statusCode: 200, headers: ["Content-Type": "application/json"])
        }
    }

    func testFetchCompletionBlock() {
        coreDataCodableTestingHelper.clearStorage(for: UserControllerTests.entityName)

        let expectation = XCTNSNotificationExpectation(name: NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue))

        userController.fetchItems { (result, error) in
            XCTAssertNil(error)
            XCTAssertTrue(result)
            XCTAssertEqual(self.userController.itemCount, self.coreDataCodableTestingHelper.numberOfItemsInPersistentStore(for: UserControllerTests.entityName))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: UserControllerTests.defaultWait)
    }

    func testParsedItemsMatch() {
        let expectedUsers: [UserViewModel]
        let jsonData = coreDataCodableTestingHelper.jsonData(for: "users.json")!
        do {
            let context = coreDataCodableTestingHelper.mockPersistentContainer.viewContext
            let users = try Users.decodeModel(from: jsonData)
            let sortedUsers = users
                .sorted { ($0?.role ?? "", $0?.username ?? "") < ($1?.role ?? "", $1?.username ?? "") }
            expectedUsers = sortedUsers.map { (user) in
                let expected = UserViewModel(user: (user!).toManagedObject(in: context)!)
                XCTAssertNotNil(expected)
                return expected
            }

            // We need to clean the storage to remove the User instances we inserted in the decoding phase!
            coreDataCodableTestingHelper.clearStorage(for: UserControllerTests.entityName)
        } catch let error {
            fatalError(error.localizedDescription)
        }

        let expectation = XCTNSNotificationExpectation(name: NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue))

        userController.fetchItems { _, _ in
            XCTAssertEqual(self.userController.itemCount, self.coreDataCodableTestingHelper.numberOfItemsInPersistentStore(for: UserControllerTests.entityName))
            for index in 0..<self.userController.itemCount {
                let actualUser = self.userController.item(at: index)
                XCTAssertNotNil(actualUser)
                XCTAssertEqual(expectedUsers[index], actualUser!)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: UserControllerTests.defaultWait)
    }

    func testFetchItemsMatch() {
        let expectedUsers: [UserViewModel]
        let jsonData = coreDataCodableTestingHelper.jsonData(for: "users.json")!
        _ = userController.parse(jsonData)
        expectedUsers = userController.fetchFromStorage()!.map { user in
            let expected = UserViewModel(user: user)
            XCTAssertNotNil(expected)
            return expected
        }

        // We need to clean the storage to remove the User instances we inserted in the decoding phase!
        coreDataCodableTestingHelper.clearStorage(for: UserControllerTests.entityName)

        let expectation = XCTNSNotificationExpectation(name: NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue))

        userController.fetchItems { _, _ in
            XCTAssertEqual(self.userController.itemCount, self.coreDataCodableTestingHelper.numberOfItemsInPersistentStore(for: UserControllerTests.entityName))
            for index in 0..<self.userController.itemCount {
                let actualUser = self.userController.item(at: index)
                XCTAssertNotNil(actualUser)
                XCTAssertEqual(expectedUsers[index], actualUser!)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: UserControllerTests.defaultWait)
    }
}
