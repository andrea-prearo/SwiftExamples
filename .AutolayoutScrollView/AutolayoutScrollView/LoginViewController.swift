//
//  LoginViewController.swift
//  AutolayoutScrollView
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import UIKit

let LoginToFirstSegue = "LoginToFirstSegue"

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    var didLayoutSubviews = false

    var initialContentSizeHeight: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        defaultCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if (didLayoutSubviews || scrollView.contentSize.height == 0.0) {
            return;
        }
        didLayoutSubviews = true
        initialContentSizeHeight = scrollView.contentSize.height
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        signInButtonTapped(textField)
        return true
    }

    // MARK: Keyboard Events

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
            var contentSize = scrollView.contentSize
            contentSize.height = initialContentSizeHeight + keyboardHeight
            scrollView.contentSize = contentSize
            scrollView.setContentOffset(CGPointMake(0, keyboardHeight), animated: true)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        var contentSize = scrollView.contentSize
        contentSize.height = initialContentSizeHeight
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func signInButtonTapped(sender: AnyObject) {
        if let username = usernameTextField.text,
            let password = passwordTextField.text
            where !username.isEmpty && !password.isEmpty {
                performSegueWithIdentifier(LoginToFirstSegue, sender: self)
        } else {
            let alert = UIAlertView(title: "Error",
                                    message: "Any non-empty username/password combination works!",
                                    delegate: nil,
                                    cancelButtonTitle: "OK")
            alert.show()
        }
    }

    // MARK: Orientation Changes

    @available(iOS 8.0, *)
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        didLayoutSubviews = false
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        guard #available(iOS 8, *) else {
            didLayoutSubviews = false
            return
        }
    }

}
