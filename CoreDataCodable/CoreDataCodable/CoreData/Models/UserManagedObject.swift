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
