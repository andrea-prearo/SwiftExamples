//
//  UserViewModel.swift
//  SmoothScrolling
//
//  Created by Prearo, Andrea on 8/10/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

struct UserViewModel {
    let avatarUrl: String
    let username: String
    let role: Role
    let roleText: String
    
    init(user: User) {
        // Avatar
        avatarUrl = user.avatarUrl
        
        // Username
        username = user.username
        
        // Role
        role = user.role
        roleText = user.role.rawValue
    }
}
