//
//  ViewController.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 3/29/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITableViewController {
    private static let UserCellReuseId = "UserCell"

    private var userController: UserControllerProtocol?

    public static func create(persistentContainer: NSPersistentContainer) -> MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let userController = UserController(persistentContainer: persistentContainer)
        mainViewController.userController = userController
        return mainViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MainViewController.UserCellReuseId)
        tableView.allowsSelection = false

        userController?.fetchItems { [weak self] (success, error) in
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
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: UITableViewDataSource

extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController?.itemCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainViewController.UserCellReuseId, for: indexPath)

        if let viewModel = userController?.item(at: indexPath.row) {
            cell.textLabel?.text = "\(viewModel.username) - \(viewModel.role)"
        } else {
            cell.textLabel?.text = "???"
        }

        return cell
    }
}
