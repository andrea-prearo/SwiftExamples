//
//  User.swift
//  SmoothScrolling
//
//  Created by Andrea Prearo on 8/10/16.
//  Copyright © 2016 Andrea Prearo. All rights reserved.
//

import Foundation

enum Role: String, Codable {
    case unknown = "Unknown"
    case user = "User"
    case owner = "Owner"
    case admin = "Admin"

    static func get(from: String) -> Role {
        if from == user.rawValue {
            return .user
        } else if from == owner.rawValue {
            return .owner
        } else if from == admin.rawValue {
            return .admin
        }
        return .unknown
    }
}

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar"
        case username
        case role
    }

    let avatarUrl: String
    let username: String
    let role: Role
    
    init(avatarUrl: String, username: String, role: Role) {
        self.avatarUrl = avatarUrl
        self.username = username
        self.role = role
    }
}
