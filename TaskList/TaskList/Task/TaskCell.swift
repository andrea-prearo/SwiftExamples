//
//  TaskCell.swift
//  TaskList
//
//  Created by Andrea Prearo on 4/19/17.
//  Copyright © 2017 Andrea Prearo. All rights reserved.
//

import UIKit

public typealias OnTaskCheckboxToggleHandlerType = (Bool) -> Void

class TaskCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkbox: UIImageView!

    // MARK: - Public Static Properties
    static var height: CGFloat = 44.0

    // MARK: - Public Properties
    var onTaskCheckboxToggleHandler: OnTaskCheckboxToggleHandlerType?
    var checked = false {
        didSet {
            checkbox.image = checked ? #imageLiteral(resourceName: "CheckboxON") : #imageLiteral(resourceName: "CheckboxOFF")
        }
    }

    // MARK: - Lifecycle
    override public func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    // MARK: - ConfigurableCell
    func configure(for item: TaskViewModel, at indexPath: IndexPath) {
        label.text = item.task.name
        checked = item.task.completed
    }
}

// MARK: - Private Methods
fileprivate extension TaskCell {
    func setUp() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggled(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        checkbox.isUserInteractionEnabled = false
    }
}

// MARK: - Actions
fileprivate extension TaskCell {
    func toggled() {
        onTaskCheckboxToggleHandler?(checked)
    }
    
    @objc func toggled(_ sender: TaskCell) {
        checked = !checked
        toggled()
    }
}
