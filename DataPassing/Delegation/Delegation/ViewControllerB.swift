//
//  ViewControllerB.swift
//  Delegation
//
//  Created by Andrea Prearo on 2/19/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import UIKit

class ViewControllerB: UIViewController {
    @IBOutlet weak var targetTextField: UITextField!
    @IBOutlet weak var goBackButton: UIButton!

    var targetText: String?
    weak var delegate: ViewControllerADelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        targetTextField.text = targetText
    }

    // MARK: - IBActions
    @IBAction func didTapGoBackButton(_ sender: Any) {
        delegate?.didChangeTargetLabel(text: targetTextField.text)
        dismiss(animated: true, completion: nil)
    }
}
