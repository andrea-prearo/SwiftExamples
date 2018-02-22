//
//  ViewControllerB.swift
//  Unwind
//
//  Created by Andrea Prearo on 2/19/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import UIKit

class ViewControllerB: UIViewController {
    @IBOutlet weak var targetTextField: UITextField!

    var targetText: String?

    private static let unwindToASegue = "unwindToASegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        targetTextField.text = targetText
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewControllerB.unwindToASegue {
            targetText = targetTextField.text
        }
    }
}
