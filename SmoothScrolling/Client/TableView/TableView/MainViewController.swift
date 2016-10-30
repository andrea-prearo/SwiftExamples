//
//  MainViewController.swift
//  TableView
//
//  Created by Prearo, Andrea on 8/10/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    fileprivate let userViewModelController = UserViewModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userViewModelController.retrieveUsers { [weak self] (success, error) in
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

// MARK: UITableViewDataSource protocol methods

extension MainViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModelController.viewModelsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell

        if let viewModel = userViewModelController.viewModel(at: (indexPath as NSIndexPath).row) {
            cell.configure(viewModel)
        }

        #if DEBUG_CELL_LIFECYCLE
        print(String.init(format: "cellForRowAt #%i", indexPath.row))
        #endif
        
        return cell
    }

    #if DEBUG_CELL_LIFECYCLE
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(String.init(format: "willDisplay #%i", indexPath.row))
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(String.init(format: "didEndDisplaying #%i", indexPath.row))
    }
    #endif

}
