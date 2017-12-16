//
//  UserController.swift
//  SmoothScrolling
//
//  Created by Andrea Prearo on 10/29/16.
//  Copyright © 2016 Andrea Prearo. All rights reserved.
//

import Foundation

class UserViewModelController {
    private var viewModels: [UserViewModel?] = []

    func retrieveUsers(_ completionBlock: @escaping (_ success: Bool, _ error: NSError?) -> ()) {
        let urlString = "https://aqueous-temple-22443.herokuapp.com/users"
        let session = URLSession.shared
        
        guard let url = URL(string: urlString) else {
            completionBlock(false, nil)
            return
        }
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            guard let jsonData = data, error == nil else {
                completionBlock(false, error as NSError?)
                return
            }
            if let users = UserViewModelController.parse(jsonData) {
                strongSelf.viewModels = UserViewModelController.initViewModels(users)
                completionBlock(true, nil)
            } else {
                completionBlock(false, NSError.createError(0, description: "JSON parsing error"))
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
    static func parse(_ jsonData: Data) -> [User?]? {
        do {
            return try JSONDecoder().decode([User].self, from: jsonData)
        } catch {
            return nil
        }
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
