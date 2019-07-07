//
//  LoginViewController.swift
//  AutoLayoutScrollView
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
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
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        defaultCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
            return false
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            signInButtonTapped(textField)
        }
        return true
    }

    // MARK: Keyboard Events

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo,
            let end = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        let keyboardHeight = end.cgRectValue.size.height
        var contentSize = scrollView.contentSize
        contentSize.height = initialContentSizeHeight + keyboardHeight
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPoint(x: 0, y: keyboardHeight), animated: true)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        var contentSize = scrollView.contentSize
        contentSize.height = initialContentSizeHeight
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func signInButtonTapped(_ sender: AnyObject) {
        if let username = usernameTextField.text,
            let password = passwordTextField.text, !username.isEmpty && !password.isEmpty {
                performSegue(withIdentifier: LoginToFirstSegue, sender: self)
        } else {
            let alert = UIAlertView(title: "Error",
                                    message: "Any non-empty username/password combination works!",
                                    delegate: nil,
                                    cancelButtonTitle: "OK")
            alert.show()
        }
    }

    // MARK: Orientation Changes

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        didLayoutSubviews = false
    }
    
}
