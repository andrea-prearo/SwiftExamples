//
//  MainViewController.swift
//  TableView
//
//  Created by Andrea Prearo on 8/10/16.
//  Copyright © 2016 Andrea Prearo. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    fileprivate let userViewModelController = UserViewModelController()

    // Pre-Fetching Queue
    fileprivate let imageLoadQueue = OperationQueue()
    fileprivate var imageLoadOperations = [IndexPath: ImageLoadOperation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Feature.initFromPList()
        if Feature.clearCaches.isEnabled {
            let cachesFolderItems = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
            for item in cachesFolderItems {
                try? FileManager.default.removeItem(atPath: item)
            }
        }

        if #available(iOS 10.0, *) {
            tableView.prefetchDataSource = self
        }
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

// MARK: UITableViewDataSource
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModelController.viewModelsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell

        if let viewModel = userViewModelController.viewModel(at: indexPath.row) {
            cell.configure(viewModel)
            if let imageLoadOperation = imageLoadOperations[indexPath],
                let image = imageLoadOperation.image {
                cell.avatar.setRoundedImage(image)
            } else {
                let imageLoadOperation = ImageLoadOperation(url: viewModel.avatarUrl)
                imageLoadOperation.completionHandler = { [weak self] (image) in
                    guard let strongSelf = self else {
                        return
                    }
                    cell.avatar.setRoundedImage(image)
                    strongSelf.imageLoadOperations.removeValue(forKey: indexPath)
                }
                imageLoadQueue.addOperation(imageLoadOperation)
                imageLoadOperations[indexPath] = imageLoadOperation
            }
        }

        if Feature.debugCellLifecycle.isEnabled {
            print(String.init(format: "cellForRowAt #%i", indexPath.row))
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if Feature.debugCellLifecycle.isEnabled {
            print(String.init(format: "willDisplay #%i", indexPath.row))
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let imageLoadOperation = imageLoadOperations[indexPath] else {
            return
        }
        imageLoadOperation.cancel()
        imageLoadOperations.removeValue(forKey: indexPath)

        if Feature.debugCellLifecycle.isEnabled {
            print(String.init(format: "didEndDisplaying #%i", indexPath.row))
        }
    }
}

// MARK: UICollectionViewDataSourcePrefetching
extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = imageLoadOperations[indexPath] {
                return
            }
            if let viewModel = userViewModelController.viewModel(at: (indexPath as NSIndexPath).row) {
                let imageLoadOperation = ImageLoadOperation(url: viewModel.avatarUrl)
                imageLoadQueue.addOperation(imageLoadOperation)
                imageLoadOperations[indexPath] = imageLoadOperation
            }

            if Feature.debugCellLifecycle.isEnabled {
                print(String.init(format: "prefetchRowsAt #%i", indexPath.row))
            }
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let imageLoadOperation = imageLoadOperations[indexPath] else {
                return
            }
            imageLoadOperation.cancel()
            imageLoadOperations.removeValue(forKey: indexPath)
            
            if Feature.debugCellLifecycle.isEnabled {
                print(String.init(format: "cancelPrefetchingForRowsAt #%i", indexPath.row))
            }
        }
    }
}
