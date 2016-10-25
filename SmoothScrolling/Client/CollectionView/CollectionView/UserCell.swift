//
//  UserCell.swift
//  TableView
//
//  Created by Prearo, Andrea on 8/10/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var role: UILabel!
    
    func configure(_ viewModel: UserViewModel) {
        setOpaqueBackground()

        avatar.downloadImageFromUrl(viewModel.avatarUrl)
        username.text = viewModel.username
        role.text = viewModel.roleText

        isUserInteractionEnabled = false  // Cell selection is not required for this sample
    }
    
}

private extension UserCell {
    static let DefaultBackgroundColor = UIColor.groupTableViewBackground

    func setOpaqueBackground() {
        alpha = 1.0
        backgroundColor = UserCell.DefaultBackgroundColor
        avatar.alpha = 1.0
        avatar.backgroundColor = UserCell.DefaultBackgroundColor
    }
}
