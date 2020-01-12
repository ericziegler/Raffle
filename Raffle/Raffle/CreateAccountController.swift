//
//  CreateAccountController.swift
//  Raffle
//
//  Created by Eric on 1/10/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let CreateAccountControllerId = "CreateAccountControllerId"

class CreateAccountController: BaseViewController {

    // MARK: - Properties
    
    @IBOutlet var nameField: StyledTextField!
    @IBOutlet var emailField: StyledTextField!
    @IBOutlet var passwordField: StyledTextField!
    @IBOutlet var textFieldBackground: UIView!
    var progressView: ProgressView?
    
    // MARK: - Init
    
    static func createController() -> CreateAccountController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: CreateAccountController = storyboard.instantiateViewController(withIdentifier: CreateAccountControllerId) as! CreateAccountController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Account"
        textFieldBackground.layer.cornerRadius = 10
        textFieldBackground.layer.borderColor = UIColor(hex: 0xdddddd).cgColor
        textFieldBackground.layer.borderWidth = 1.5
    }
    
    // MARK: - Actions
    
    @IBAction func createAccountTapped(_ sender: AnyObject) {
        if isPasswordValid() == true {
            if let name = nameField.text, let email = emailField.text, let password = Organization.encodeAndCleanPassword(passwordField.text) {
                progressView = ProgressView.createProgressFor(parentController: navigationController!, title: "Signing In")
                Organization.shared.createAccountWith(name: name, email: email, password: password) { (error) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                         self.progressView?.hideProgress()
                         self.progressView = nil
                         if let _ = error {
                             // TODO: Display an alert that we were unable to sign in
                         } else {
                             // TODO: Move to Organization screenr
                         }
                     }
                }
            } else {
                // TODO: Display an alert that all fields must be filled out
            }
        } else {
            // TODO: Display an alert that password must contain at least one number and be at least eight characters            
        }
    }
    
    // MARK: - Helpers
    
    private func isPasswordValid() -> Bool {
        var result = false
        if let password = passwordField.text {
            if password.count > 7 && password.rangeOfCharacter(from: .decimalDigits) != nil && password.rangeOfCharacter(from: .letters) != nil {
                result = true
            }
        }
        return result
    }
    
}

// MARK: - UITextFieldDelegate

extension CreateAccountController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
