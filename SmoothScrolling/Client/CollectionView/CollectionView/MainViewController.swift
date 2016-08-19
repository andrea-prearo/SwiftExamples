//
//  MainViewController.swift
//  CollectionView
//
//  Created by Prearo, Andrea on 8/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
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
                    strongSelf.collectionView?.reloadData()
                }
            }
        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
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

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCell", forIndexPath: indexPath) as! UserCell

        if let viewModel = viewModels[indexPath.row] {
            cell.configure(viewModel)
        }
        
        return cell
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout protocol methods

extension MainViewController {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let columns: Int = {
            var count = 2
            if traitCollection.horizontalSizeClass == .Regular {
                count = count + 1
            }
            if collectionView.bounds.width > collectionView.bounds.height {
                count = count + 1
            }
            return count
        }()
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(columns - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(columns))
        return CGSize(width: size, height: 90)
    }

}
