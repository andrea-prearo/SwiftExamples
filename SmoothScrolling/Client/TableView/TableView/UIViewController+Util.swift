//
//  UIViewController+Util.swift
//  TableView
//
//  Created by Prearo, Andrea on 8/18/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
