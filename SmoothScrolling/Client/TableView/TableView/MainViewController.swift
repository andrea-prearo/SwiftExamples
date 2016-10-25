//
//  MainViewController.swift
//  TableView
//
//  Created by Prearo, Andrea on 8/10/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    fileprivate var viewModels: [UserViewModel?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        User.getAll { [weak self] (success, users, error) in
            guard let strongSelf = self else { return }
            if !success {
                DispatchQueue.main.async {
                    let title = "Error"
                    if let error = error {
                        strongSelf.showError(title, message: error.localizedDescription)
                    } else {
                        strongSelf.showError(title, message: NSLocalizedString("Can't retrieve contacts.", comment: "Can't retrieve contacts."))
                    }
                }
            } else {
                if let users = users {
                    strongSelf.viewModels = MainViewController.initViewModels(users)
                } else {
                    strongSelf.viewModels = []
                }
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }

}

// MARK: private methods

extension MainViewController {

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

// MARK: UITableViewDataSource protocol methods

extension MainViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell

        if let viewModel = viewModels[(indexPath as NSIndexPath).row] {
            cell.configure(viewModel)
        }
        
        return cell
    }

}
