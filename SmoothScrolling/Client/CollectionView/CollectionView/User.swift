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

    static func role(from from: String) -> Role {
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
    
    init(avatarUrl: String,
         username: String,
         role: Role)
    {
        self.avatarUrl = avatarUrl
        self.username = username
        self.role = role
    }
}

extension User {

    static func getAll(completionBlock: (success: Bool, users: [User?]?, error: NSError?) -> ()) {
        let urlString = "http://localhost:3000/users"
        let session = NSURLSession.sharedSession()
        
        guard let url = NSURL(string: urlString) else {
            completionBlock(success: false, users: nil, error: nil)
            return
        }
        let task = session.dataTaskWithURL(url) { (data, response, error) in
            guard let data = data else {
                completionBlock(success: false, users: nil, error: error)
                return
            }
            let error =  NSError.createError(0, description: "JSON parsing error")
            if let jsonData = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [[String: AnyObject]] {
                guard let jsonData = jsonData else {
                    completionBlock(success: false, users: nil, error: error)
                    return
                }
                var users = [User?]()
                for json in jsonData {
                    if let user = User.parse(json) {
                        users.append(user)
                    }
                }
                completionBlock(success: true, users: users, error: nil)
            } else {
                completionBlock(success: false, users: nil, error: error)
            }
        }
        task.resume()
    }
    
}

private extension User {

    static func parse(json: [String: AnyObject]) -> User? {
        let avatarUrl = json["avatar"] as? String ?? ""
        let username = json["username"] as? String ?? ""
        let role = json["role"] as? String ?? ""
        return User(avatarUrl: avatarUrl, username: username, role: Role.role(from: role))
    }
}

