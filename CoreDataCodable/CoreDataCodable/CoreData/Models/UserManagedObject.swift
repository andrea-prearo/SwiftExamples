//
//  UserManagedObject.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 12/29/21.
//  Copyright © 2021 Andrea Prearo. All rights reserved.
//

import CoreData
import Foundation

enum UserRole: String {
    case unknown = "Unknown"
    case admin = "Admin"
    case owner = "Owner"
    case user = "User"

    static func fromString(_ value: String?) -> UserRole {
        guard let value = value else { return .unknown }
        return UserRole(rawValue: value) ?? .unknown
    }
}

//// MARK: - Core Data Managed Object
@objc(UserManagedObject)
class UserManagedObject: NSManagedObject {
    @NSManaged var avatarUrl: String?
    @NSManaged var username: String?
    @NSManaged private var roleValue: String

    var role: UserRole {
        get {
            return UserRole.fromString(roleValue)
        }
        set {
            roleValue = newValue.rawValue
        }
    }
}

extension UserManagedObject: ModelConvertible {
    // MARK: - ManagedObjectDelegate
    /// The managed entity name.
    static var entityName = "User"

    /// The entity default sort descriptors.
    static var sortDescriptors: [NSSortDescriptor]? { return nil }

    /// The default sorted fetch request.
    static var sortedFetchRequest: NSFetchRequest<UserManagedObject> {
        let request: NSFetchRequest<UserManagedObject> = self.fetchRequest()
        request.sortDescriptors = UserManagedObject.sortDescriptors
        return request
    }

    /// Returns the default fetch request (default descriptors and sorting).
    ///
    /// - Returns: The default fetch request.
    static func fetchRequest() -> NSFetchRequest<UserManagedObject> {
        return NSFetchRequest<UserManagedObject>(entityName: entityName)
    }

    // MARK: - ModelConvertible
    /// Converts a UserManagedObject instance to a User instance.
    ///
    /// - Returns: The converted User instance.
    func toModel() -> User? {
        return User(avatarUrl: avatarUrl,
                    username: username,
                    role: role.rawValue)
    }
}
