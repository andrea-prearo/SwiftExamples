//
//  ViewControllerA.swift
//  Delegation
//
//  Created by Andrea Prearo on 2/19/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import UIKit

// Passing Data Between View Controllers in iOS: the Definitive Guide
// http://matteomanferdini.com/how-ios-view-controllers-communicate-with-each-other/

protocol ViewControllerADelegate: class {
    func didChangeTargetLabel(text: String?)
}

class ViewControllerA: UIViewController, ViewControllerADelegate {
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var navigateButton: UIButton!

    private static let toBSegue = "AToBSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        targetLabel.text = "Test"
    }

    // MARK: - ViewControllerADelegate
    func didChangeTargetLabel(text: String?) {
        targetLabel.text = text
    }

    // MARK: - IBActions
    @IBAction func didTapNavigateButton(_ sender: Any) {
        performSegue(withIdentifier: ViewControllerA.toBSegue, sender: self)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewControllerA.toBSegue {
            guard let viewControllerB = segue.destination as? ViewControllerB else {
                return
            }
            viewControllerB.targetText = targetLabel.text
            viewControllerB.delegate = self
        }
    }
}
