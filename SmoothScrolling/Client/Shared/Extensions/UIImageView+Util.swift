//
//  UIImageView+Util.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/9/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit

extension UIImageView {

    static func defaultAvatarImage() -> UIImage? {
        return UIImage(named: "Avatar")
    }

    func downloadImageFromUrl(_ url: String, defaultImage: UIImage? = UIImageView.defaultAvatarImage()) {
        guard let url = URL(string: url)
        else {
            setRoundedImage(defaultImage)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data , error == nil,
                let image = UIImage(data: data)
            else {
                self?.setRoundedImage(defaultImage)
                return
            }
            self?.setRoundedImage(image)
        }).resume()
    }

}

private extension UIImageView {
    
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
