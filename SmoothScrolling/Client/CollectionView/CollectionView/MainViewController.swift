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
    fileprivate let userViewModelController = UserViewModelController()

    // Pre-Fetching Queue
    fileprivate let imageLoadQueue = OperationQueue()
    fileprivate var imageLoadOperations = [IndexPath: ImageLoadOperation]()

    override func viewDidLoad() {
        super.viewDidLoad()

        #if CLEAR_CACHES
        let cachesFolderItems = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        for item in cachesFolderItems {
            try? FileManager.default.removeItem(atPath: item)
        }
        #endif

        if #available(iOS 10.0, *) {
            collectionView?.prefetchDataSource = self
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
                    strongSelf.collectionView?.reloadData()
                }
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.collectionView?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

// MARK: UICollectionViewDataSource

extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userViewModelController.viewModelsCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell

        if let viewModel = userViewModelController.viewModel(at: (indexPath as NSIndexPath).row) {
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
        
        #if DEBUG_CELL_LIFECYCLE
        print(String.init(format: "cellForRowAt #%i", indexPath.row))
        #endif

        return cell
    }

    #if DEBUG_CELL_LIFECYCLE
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(String.init(format: "willDisplay #%i", indexPath.row))
    }
    #endif

    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let imageLoadOperation = imageLoadOperations[indexPath] else {
            return
        }
        imageLoadOperation.cancel()
        imageLoadOperations.removeValue(forKey: indexPath)
        
        #if DEBUG_CELL_LIFECYCLE
        print(String.init(format: "didEndDisplaying #%i", indexPath.row))
        #endif
    }
}

// MARK: UICollectionViewDelegateFlowLayout protocol methods

extension MainViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
}

// MARK: UICollectionViewDataSourcePrefetching

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = imageLoadOperations[indexPath] {
                return
            }
            if let viewModel = userViewModelController.viewModel(at: (indexPath as NSIndexPath).row) {
                let imageLoadOperation = ImageLoadOperation(url: viewModel.avatarUrl)
                imageLoadQueue.addOperation(imageLoadOperation)
                imageLoadOperations[indexPath] = imageLoadOperation
            }
            
            #if DEBUG_CELL_LIFECYCLE
            print(String.init(format: "prefetchItemsAt #%i", indexPath.row))
            #endif
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let imageLoadOperation = imageLoadOperations[indexPath] else {
                return
            }
            imageLoadOperation.cancel()
            imageLoadOperations.removeValue(forKey: indexPath)
            
            #if DEBUG_CELL_LIFECYCLE
            print(String.init(format: "cancelPrefetchingForItemsAt #%i", indexPath.row))
            #endif
        }
    }
}
