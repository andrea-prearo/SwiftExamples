//
//  UserViewModel.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 3/29/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import Foundation

struct UserViewModel {
    let avatarUrl: String
    let username: String
    let role: String
    
    init(user: User) {
        // Avatar
        avatarUrl = String.emptyIfNil(user.avatarUrl)
        
        // Username
        username = String.emptyIfNil(user.username)
        
        // Role
        role = String.emptyIfNil(user.role)
    }
}
