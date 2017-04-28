//
//  UserController.swift
//  SmoothScrolling
//
//  Created by Andrea Prearo on 10/29/16.
//  Copyright © 2016 Andrea Prearo. All rights reserved.
//

import Foundation

class UserViewModelController {
    fileprivate var viewModels: [UserViewModel?] = []

    func retrieveUsers(_ completionBlock: @escaping (_ success: Bool, _ error: NSError?) -> ()) {
        let urlString = "http://localhost:3000/users"
        let session = URLSession.shared
        
        guard let url = URL(string: urlString) else {
            completionBlock(false, nil)
            return
        }
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            guard let data = data else {
                completionBlock(false, error as NSError?)
                return
            }
            let error = NSError.createError(0, description: "JSON parsing error")
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]] {
                guard let jsonData = jsonData else {
                    completionBlock(false,  error)
                    return
                }
                var users = [User?]()
                for json in jsonData {
                    if let user = UserViewModelController.parse(json) {
                        users.append(user)
                    }
                }

                strongSelf.viewModels = UserViewModelController.initViewModels(users)
                completionBlock(true, nil)
            } else {
                completionBlock(false, error)
            }
        }
        task.resume()
    }

    var viewModelsCount: Int {
        return viewModels.count
    }

    func viewModel(at index: Int) -> UserViewModel? {
        guard index >= 0 && index < viewModelsCount else { return nil }
        return viewModels[index]
    }
}

private extension UserViewModelController {
    static func parse(_ json: [String: AnyObject]) -> User? {
        let avatarUrl = json["avatar"] as? String ?? ""
        let username = json["username"] as? String ?? ""
        let role = json["role"] as? String ?? ""
        return User(avatarUrl: avatarUrl, username: username, role: Role.get(from: role))
    }

    static func initViewModels(_ users: [User?]) -> [UserViewModel?] {
        return users.map { user in
            if let user = user {
                return UserViewModel(user: user)
            } else {
                return nil
            }
        }
    }
}
