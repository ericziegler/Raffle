//
//  SignInController.swift
//  Raffle
//
//  Created by Eric on 1/10/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let SignInControllerId = "SignInControllerId"

class SignInController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet var emailField: StyledTextField!
    @IBOutlet var passwordField: StyledTextField!
    @IBOutlet var textFieldBackground: UIView!
    var progressView: ProgressView?
    
    // MARK: - Init
    
    static func createController() -> SignInController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SignInControllerId) as! SignInController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        textFieldBackground.layer.cornerRadius = 10
        textFieldBackground.layer.borderColor = UIColor(hex: 0xdddddd).cgColor
        textFieldBackground.layer.borderWidth = 1.5
    }
    
    // MARK: - Actions
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let password = Organization.encodePassword(passwordField.text) {
            view.endEditing(true)
            progressView = ProgressView.createProgressFor(parentController: navigationController!, title: "Signing In")
            Organization.shared.loginWith(email: email, password: password) { (error) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.progressView?.hideProgress()
                    self.progressView = nil
                    if let _ = error {
                        let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Sign In Failed", message: "We were unable to sign in using this email and password.", okButton: "OK", cancelButton: nil)
                        alert.showAlert()
                    } else {
                        // TODO: Move to Organization screenr
                    }
                }
            }
        } else {
            let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "Empty Fields", message: "All fields must be filled out before continuing.", okButton: "OK", cancelButton: nil)
            alert.showAlert()
        }
    }
    
    @IBAction func resetPasswordTapped(_ sender: AnyObject) {
        // TODO: Implement reset password option
    }
    
}

// MARK: - UITextFieldDelegate

extension SignInController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
