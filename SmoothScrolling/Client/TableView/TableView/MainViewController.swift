//
//  MainViewController.swift
//  TableView
//
//  Created by Prearo, Andrea on 8/10/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    private var viewModels: [UserViewModel?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        User.getAll { [weak self] (success, users, error) in
            guard let strongSelf = self else { return }
            if !success {
                dispatch_async(dispatch_get_main_queue()) {
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
                dispatch_async(dispatch_get_main_queue()) {
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }

}

// MARK: private methods

extension MainViewController {

    static func initViewModels(users: [User?]) -> [UserViewModel?] {
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell

        if let viewModel = viewModels[indexPath.row] {
            cell.configure(viewModel)
        }
        
        return cell
    }

}
