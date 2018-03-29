//
//  User.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 3/29/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar"
        case username
        case role
    }

    // MARK: - Core Data Managed Object
    @NSManaged var avatarUrl: String?
    @NSManaged var username: String?
    @NSManaged var role: String?

    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext) else {
            fatalError("Failed to decode User")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.avatarUrl = try container.decodeIfPresent(String.self, forKey: .avatarUrl)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.role = try container.decodeIfPresent(String.self, forKey: .role)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(avatarUrl, forKey: .avatarUrl)
        try container.encode(username, forKey: .username)
        try container.encode(role, forKey: .role)
    }
}
