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
        if let email = emailField.text, let password = Organization.encodeAndCleanPassword(passwordField.text) {
            Organization.shared.loginWith(email: email, password: password) { (error) in
                if let _ = error {
                    // TODO: Display an alert that we were unable to sign in
                } else {
                    // TODO: Move to Organization screenr
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Logged in to \(Organization.shared.name)", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Great Jarb", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }   
                }
            }
        } else {
            // TODO: Display an alert that all fields must be filled out
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
