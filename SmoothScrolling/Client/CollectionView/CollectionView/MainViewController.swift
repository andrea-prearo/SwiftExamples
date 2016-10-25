//
//  MainViewController.swift
//  CollectionView
//
//  Created by Prearo, Andrea on 8/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate static let sectionInsets = UIEdgeInsetsMake(0, 2, 0, 2)
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
                    strongSelf.collectionView?.reloadData()
                }
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
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

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell

        if let viewModel = viewModels[(indexPath as NSIndexPath).row] {
            cell.configure(viewModel)
        }
        
        return cell
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout protocol methods

extension MainViewController {

    @objc(collectionView:layout:sizeForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let columns: Int = {
            var count = 2
            if traitCollection.horizontalSizeClass == .regular {
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
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return MainViewController.sectionInsets
//    }

}
