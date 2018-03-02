//
//  ViewControllerA.swift
//  Unwind
//
//  Created by Andrea Prearo on 2/19/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import UIKit

// Passing Data Between View Controllers in iOS: the Definitive Guide
// http://matteomanferdini.com/how-ios-view-controllers-communicate-with-each-other/

class ViewControllerA: UIViewController {
    @IBOutlet weak var targetLabel: UILabel!

    private static let toBSegue = "AToBSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewControllerA.toBSegue {
            guard let viewControllerB = segue.destination as? ViewControllerB else {
                return
            }
            viewControllerB.targetText = targetLabel.text
        }
    }

    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        guard let viewControllerB = segue.source as? ViewControllerB else {
            return
        }
        targetLabel.text = viewControllerB.targetText
    }
}
