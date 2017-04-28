//
//  UserCell.swift
//  CollectionView
//
//  Created by Andrea Prearo on 8/10/16.
//  Copyright © 2016 Andrea Prearo. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var role: UILabel!

    static let defaultAvatar = UIImage(named: "Avatar")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setOpaqueBackground()
        avatar.setRoundedImage(UserCell.defaultAvatar)
    }

    func configure(_ viewModel: UserViewModel) {
        // The avatar property will be assigned asynchronously through an ImageLoadOperation
        username.text = viewModel.username
        role.text = viewModel.roleText

        isUserInteractionEnabled = false  // Cell selection is not required for this sample
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.setRoundedImage(UserCell.defaultAvatar)
    }
}

private extension UserCell {
    static let defaultBackgroundColor = UIColor.groupTableViewBackground

    func setOpaqueBackground() {
        alpha = 1.0
        backgroundColor = UserCell.defaultBackgroundColor
        avatar.alpha = 1.0
        avatar.backgroundColor = UserCell.defaultBackgroundColor
    }
}
