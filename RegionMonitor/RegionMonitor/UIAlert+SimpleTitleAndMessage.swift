//
//  UIAlert+SimpleTitleAndMessage.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import UIKit

extension UIAlertView {

    class func showSimpleAlert(_ title: String?, message: String?) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
        alert.show()
    }

}
