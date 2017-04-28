//
//  UIImageView+Util.swift
//  SmoothScrolling
//
//  Created by Andrea Prearo on 3/9/16.
//  Copyright © 2016 Andrea Prearo. All rights reserved.
//

import UIKit

extension UIImageView {
    func setRoundedImage(_ image: UIImage?) {
        guard let image = image else {
            return
        }
        DispatchQueue.main.async { [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.image = image
            strongSelf.roundedImage(10.0)
        }
    }
}

private extension UIImageView {
    func roundedImage(_ cornerRadius: CGFloat, withBorder: Bool = true) {
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        if withBorder {
            layer.borderColor = UIColor.white.cgColor
        }
        clipsToBounds = true
    }
}
