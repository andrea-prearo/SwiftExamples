//
//  UserController.swift
//  SmoothScrolling
//
//  Created by Andrea Prearo on 10/29/16.
//  Copyright © 2016 Andrea Prearo. All rights reserved.
//

import Foundation

typealias RetrieveUsersCompletionBlock = (_ success: Bool, _ error: NSError?) -> Void

class UserViewModelController {
    private static let pageSize = 25

    private var viewModels: [UserViewModel?] = []
    private var currentPage = -1
    private var lastPage = -1
    private var retrieveUsersCompletionBlock: RetrieveUsersCompletionBlock?

    func retrieveUsers(_ completionBlock: @escaping RetrieveUsersCompletionBlock) {
        retrieveUsersCompletionBlock = completionBlock
        loadNextPageIfNeeded(for: 0)
    }

    var viewModelsCount: Int {
        return viewModels.count
    }

    func viewModel(at index: Int) -> UserViewModel? {
        guard index >= 0 && index < viewModelsCount else { return nil }
        loadNextPageIfNeeded(for: index)
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

    func loadNextPageIfNeeded(for index: Int) {
        let targetCount = currentPage < 0 ? 0 : (currentPage + 1) * UserViewModelController.pageSize - 1
        guard index == targetCount else {
            return
        }
        currentPage += 1
        let id = currentPage * UserViewModelController.pageSize + 1
        let urlString = String(format: "https://aqueous-temple-22443.herokuapp.com/users?id=\(id)&count=\(UserViewModelController.pageSize)")
        guard let url = URL(string: urlString) else {
            retrieveUsersCompletionBlock?(false, nil)
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            guard let jsonData = data, error == nil else {
                DispatchQueue.main.async {
                    strongSelf.retrieveUsersCompletionBlock?(false, error as NSError?)
                }
                return
            }
            strongSelf.lastPage += 1
            if let users = UserViewModelController.parse(jsonData) {
                let newUsersPage = UserViewModelController.initViewModels(users)
                strongSelf.viewModels.append(contentsOf: newUsersPage)
                DispatchQueue.main.async {
                    strongSelf.retrieveUsersCompletionBlock?(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.retrieveUsersCompletionBlock?(false, NSError.createError(0, description: "JSON parsing error"))
                }
            }
        }
        task.resume()
    }
}
