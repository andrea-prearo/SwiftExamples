//
//  CoreDataCodableTestingHelper.swift
//  CoreDataCodableTests
//
//  Created by Andrea Prearo on 3/29/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import XCTest
import CoreData
import OHHTTPStubs
import OHHTTPStubsSwift

class CoreDataCodableTestingHelper {
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()

    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataCodable", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            if let error = error {
                XCTFail("Error creating the in-memory NSPersistentContainer mock: \(error)")
            }
        }

        return container
    }()

    func stubResponse(for fileName: String, statusCode: Int32 = 200) -> HTTPStubsResponse {
        let path = OHPathForFile(fileName, type(of: self))!
        let result = fixture(filePath: path,
                             status: statusCode,
                             headers: ["Content-Type": "application/json"])
        return result
    }

    func jsonData(for fileName: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        if let path = OHPathForFileInBundle(fileName, bundle) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        return nil
    }

    func numberOfItemsInPersistentStore(for entityName: String) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let results = try! mockPersistentContainer.viewContext.fetch(request)
        return results.count
    }

    func clearStorage(for entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let context = mockPersistentContainer.viewContext
        let objs = try! context.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            context.delete(obj)
        }
        try! context.save()
    }
}
