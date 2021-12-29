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
            return request.url!.path.contains("users")
        } response: { _ in
            return self.coreDataCodableTestingHelper.stubResponse(for: "users.json", statusCode: 200)
        }
    }

    func testFetchCompletionBlock() {
        let expectation = XCTNSNotificationExpectation(name: NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue))

        userController.fetchItems { (result, error) in
            XCTAssertNil(error)
            XCTAssertTrue(result)
            XCTAssertEqual(self.userController.itemCount, self.coreDataCodableTestingHelper.numberOfItemsInPersistentStore(for: UserControllerTests.entityName))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: UserControllerTests.defaultWait)
    }

    func testFetchItemsMatch() {
        let expectedUsers: [UserViewModel]
        let jsonData = coreDataCodableTestingHelper.jsonData(for: "users.json")
        do {
            let managedObjectContext = coreDataCodableTestingHelper.mockPersistentContainer.viewContext
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = managedObjectContext
            let users = try decoder.decode([User].self, from: jsonData!)
            let sortDescriptor1 = NSSortDescriptor(key: "role", ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: "username", ascending: true)
            let sortedUsers = (users as NSArray).sortedArray(using: [sortDescriptor1, sortDescriptor2])
            expectedUsers = sortedUsers.map { (user) in
                let expected = UserViewModel(user: user as! User)
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
}
