//
//  UIAlert+SimpleTitleAndMessage.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import UIKit

extension UIAlertView {
    class func showSimpleAlert(title: String?, message: String?) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
        alert.show()
    }
}
