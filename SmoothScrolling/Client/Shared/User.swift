//
//  User.swift
//  TableView
//
//  Created by Prearo, Andrea on 8/10/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

enum Role: String {
    case Unknown = "Unknown"
    case User = "User"
    case Owner = "Owner"
    case Admin = "Admin"

    static func get(from: String) -> Role {
        if from == User.rawValue {
            return .User
        } else if from == Owner.rawValue {
            return .Owner
        } else if from == Admin.rawValue {
            return .Admin
        }
        return .Unknown
    }
}

struct User {
    let avatarUrl: String
    let username: String
    let role: Role
    
    init(avatarUrl: String, username: String, role: Role) {
        self.avatarUrl = avatarUrl
        self.username = username
        self.role = role
    }
}
