//
//  ViewController.swift
//  Solution
//
//  Created by Prearo, Andrea on 10/11/17.
//  Copyright © 2017 Prearo, Andrea. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bookingCoordinator = BookingCoordinator()
        bookingCoordinator.fetch()
    }

}
