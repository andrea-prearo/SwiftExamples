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

    func downloadImageFromUrl(url: String, defaultImage: UIImage? = UIImageView.defaultAvatarImage()) {
        guard let url = NSURL(string: url)
        else {
            setRoundedImage(defaultImage)
            return
        }
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
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
    
    func setRoundedImage(image: UIImage?) {
        guard let image = image else {
            return
        }
        dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
            guard let strongSelf = self else { return }
            strongSelf.image = image
            strongSelf.roundedImage(10.0)
        }
    }

    func roundedImage(cornerRadius: CGFloat, withBorder: Bool = true) {
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        if withBorder {
            layer.borderColor = UIColor.whiteColor().CGColor
        }
        clipsToBounds = true
    }

}
