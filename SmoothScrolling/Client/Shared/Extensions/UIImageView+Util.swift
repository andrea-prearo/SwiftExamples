//
//  UIImageView+Util.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/9/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit

extension UIImageView {

    func downloadImageFromUrl(_ url: String, completionHandler: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: url)
        else {
            completionHandler(nil)
            return nil
        }
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data , error == nil,
                let image = UIImage(data: data)
            else {
                completionHandler(nil)
                return
            }
            completionHandler(image)
        })
        task.resume()
        return task
    }

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
