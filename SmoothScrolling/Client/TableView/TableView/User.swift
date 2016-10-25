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

    static func role(from: String) -> Role {
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

    static func getAll(_ completionBlock: @escaping (_ success: Bool, _ users: [User?]?, _ error: NSError?) -> ()) {
        let urlString = "http://localhost:3000/users"
        let session = URLSession.shared
        
        guard let url = URL(string: urlString) else {
            completionBlock(false, nil, nil)
            return
        }
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionBlock(false, nil, error as NSError?)
                return
            }
            let error =  NSError.createError(0, description: "JSON parsing error")
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]] {
                guard let jsonData = jsonData else {
                    completionBlock(false, nil, error)
                    return
                }
                var users = [User?]()
                for json in jsonData {
                    if let user = User.parse(json) {
                        users.append(user)
                    }
                }
                completionBlock(true, users, nil)
            } else {
                completionBlock(false, nil, error)
            }
        }) 
        task.resume()
    }
    
}

private extension User {

    static func parse(_ json: [String: AnyObject]) -> User? {
        let avatarUrl = json["avatar"] as? String ?? ""
        let username = json["username"] as? String ?? ""
        let role = json["role"] as? String ?? ""
        return User(avatarUrl: avatarUrl, username: username, role: Role.role(from: role))
    }
}

