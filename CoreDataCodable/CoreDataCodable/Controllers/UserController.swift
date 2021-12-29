//
//  UserController.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 3/29/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import Foundation
import CoreData

typealias FetchItemsCompletionBlock = (_ success: Bool, _ error: NSError?) -> Void

// MARK: - UserControllerProtocol

protocol UserControllerProtocol {
    var items: [UserViewModel?]? { get }
    var itemCount: Int { get }

    func item(at index: Int) -> UserViewModel?
    func fetchItems(_ completionBlock: @escaping FetchItemsCompletionBlock)
}

extension UserControllerProtocol {
    var items: [UserViewModel?]? {
        return items
    }

    var itemCount: Int {
        return items?.count ?? 0
    }

    func item(at index: Int) -> UserViewModel? {
        guard index >= 0 && index < itemCount else { return nil }
        return items?[index] ?? nil
    }
}

// MARK: - UserController

class UserController: UserControllerProtocol {
    private static let pageSize = 100
    private static let entityName = "User"

    private let persistentContainer: NSPersistentContainer

    private var currentPage = -1
    private var lastPage = -1
    private var fetchItemsCompletionBlock: FetchItemsCompletionBlock?

    var items: [UserViewModel?]? = []

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func fetchItems(_ completionBlock: @escaping FetchItemsCompletionBlock) {
        fetchItemsCompletionBlock = completionBlock
        loadNextPageIfNeeded(for: 0)
    }

    func item(at index: Int) -> UserViewModel? {
        guard index >= 0 && index < itemCount else { return nil }
        loadNextPageIfNeeded(for: index)
        return items?[index] ?? nil
    }
}

internal extension UserController {
    func parse(_ jsonData: Data) -> Bool {
        do {
            // Clear storage and save managed object instances
            if currentPage == 0 {
                clearStorage()
            }

            // Parse JSON data
            let users = try Users.decodeModel(from: jsonData)

            // Update CoreData
            let managedObjectContext = persistentContainer.viewContext
            _ = users.map { $0?.toManagedObject(in: managedObjectContext) }

            return true
        } catch let error {
            print(error)
            return false
        }
    }

    func fetchFromStorage() -> [UserManagedObject]? {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UserManagedObject>(entityName: UserController.entityName)
        let sortDescriptor1 = NSSortDescriptor(key: "roleValue", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "username", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        do {
            let users = try managedObjectContext.fetch(fetchRequest)
            return users
        } catch let error {
            print(error)
            return nil
        }
    }

    func clearStorage() {
        let isInMemoryStore = persistentContainer.persistentStoreDescriptions.reduce(false) {
            return $0 ? true : $1.type == NSInMemoryStoreType
        }

        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: UserController.entityName)
        // NSBatchDeleteRequest is not supported for in-memory stores
        if isInMemoryStore {
            do {
                let users = try managedObjectContext.fetch(fetchRequest)
                for user in users {
                    managedObjectContext.delete(user as! NSManagedObject)
                }
            } catch let error as NSError {
                print(error)
            }
        } else {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(batchDeleteRequest)
            } catch let error as NSError {
                print(error)
            }
        }
    }

    static func initViewModels(_ users: [UserManagedObject?]) -> [UserViewModel?] {
        return users.map { user in
            if let user = user {
                return UserViewModel(user: user)
            } else {
                return nil
            }
        }
    }

    func loadNextPageIfNeeded(for index: Int) {
        let targetCount = currentPage < 0 ? 0 : (currentPage + 1) * UserController.pageSize - 1
        guard index == targetCount else {
            return
        }
        currentPage += 1
        let id = currentPage * UserController.pageSize + 1
        let urlString = String(format: "https://aqueous-temple-22443.herokuapp.com/users?id=\(id)&count=\(UserController.pageSize)")
        guard let url = URL(string: urlString) else {
            fetchItemsCompletionBlock?(false, nil)
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            guard let jsonData = data, error == nil else {
                DispatchQueue.main.async {
                    self.fetchItemsCompletionBlock?(false, error as NSError?)
                }
                return
            }
            self.lastPage += 1
            if self.parse(jsonData) {
                if let users = self.fetchFromStorage() {
                    let newUsersPage = UserController.initViewModels(users)
                    self.items?.append(contentsOf: newUsersPage)
                }
                DispatchQueue.main.async {
                    self.fetchItemsCompletionBlock?(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.fetchItemsCompletionBlock?(false, NSError.createError(0, description: "JSON parsing error"))
                }
            }
        }
        task.resume()
    }
}
