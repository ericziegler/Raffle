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
        if let name = nameField.text, let email = emailField.text, let password = Organization.encodeAndCleanPassword(passwordField.text) {
            Organization.shared.createAccountWith(name: name, email: email, password: password) { (error) in
                if let _ = error {
                    // TODO: Display an alert that we were unable to create an account
                } else {
                    // TODO: Move to Organization screen
                }
            }
        } else {
            // TODO: Display an alert that all fields must be filled out
        }
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
