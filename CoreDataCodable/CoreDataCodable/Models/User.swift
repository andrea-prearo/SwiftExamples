//
//  User.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 3/29/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import Foundation
import CoreData

struct User: Codable, Equatable, CodableModel {
    typealias Model = User
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar"
        case username
        case role
    }

    let avatarUrl: String?
    let username: String?
    let role: String?
}

extension User: ManagedObjectConvertible {
    func toManagedObject(in context: NSManagedObjectContext) -> UserManagedObject? {
        let entityName = UserManagedObject.entityName
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            NSLog("Can't create entity \(entityName)")
            return nil
        }
        let object = UserManagedObject.init(entity: entityDescription, insertInto: context)
        object.avatarUrl = avatarUrl
        object.username = username
        object.role = UserRole.fromString(role)
        return object
    }
}
