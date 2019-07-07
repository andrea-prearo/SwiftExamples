//
//  UIAlertController+Extensions.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 7/6/19.
//  Copyright © 2019 aprearo. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showSimpleAlert(_ vc: UIViewController, title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.show(vc, sender: nil)
    }
}
