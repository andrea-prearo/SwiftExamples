//
//  TasksViewController.swift
//  TaskList
//
//  Created by Andrea Prearo on 4/28/17.
//  Copyright © 2017 Andrea Prearo. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {
    @IBOutlet weak var groupButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    static let headerIdentifier = String(describing: TaskHeaderView.self)
    static let cellIdentifier = String(describing: TaskCell.self)
    
    fileprivate var tasksDataSource: TasksDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        tasksDataSource = setUpDataSource()
    }

    @IBAction func group(_ sender: UIBarButtonItem) {
        let isGrouped = !(tasksDataSource?.isGrouped ?? true)
        tasksDataSource?.isGrouped = isGrouped
        groupButton.title = isGrouped ? "Ungroup" : "Group"
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension TasksViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tasksDataSource?.numberOfSections() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksDataSource?.numberOfItems(inSection: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TasksViewController.headerIdentifier, for: indexPath)
            if let tasksDataSource = tasksDataSource,
                let header = header as? TaskHeaderView {
                header.sectionLabel.text = tasksDataSource.header(for: indexPath.section)?.sectionText ?? ""
            }
            return header
        default:
            fatalError("Could not find supplementary view of \(kind)!")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TasksViewController.cellIdentifier, for: indexPath) as! TaskCell
        if let tasksDataSource = tasksDataSource,
            let viewModel = tasksDataSource.item(at: indexPath) {
            cell.configure(for: viewModel, at: indexPath)
            cell.onTaskCheckboxToggleHandler = { [weak self] checked in
                self?.tasksDataSource?.updateItem(at: indexPath, checked: checked)
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TasksViewController: UICollectionViewDelegateFlowLayout {
    func setUpDataSource() -> TasksDataSource? {
        var dataSource = TasksDataSource()
        dataSource.tasks = (1...50).map {
            return Task(name: "Task #\($0)", priority: Priority.random(), completed: false)
        }
        return dataSource
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let tasksDataSource = tasksDataSource, tasksDataSource.isGrouped else {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.size.width, height: TaskHeaderView.height)
    }
}
