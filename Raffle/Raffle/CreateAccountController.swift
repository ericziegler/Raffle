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
    @IBOutlet var backgroundTopConstraint: NSLayoutConstraint!
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
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Actions
    
    @IBAction func createAccountTapped(_ sender: AnyObject) {
            if nameField.isNilOrEmpty() == false && emailField.isNilOrEmpty() == false && passwordField.isNilOrEmpty() == false, let password = Organization.encodePassword(passwordField.text) {
                if isPasswordValid() == true {
                    view.endEditing(true)
                    resetTopConstraint()
                    progressView = ProgressView.createProgressFor(parentController: navigationController!, title: "Creating Account")
                    Organization.shared.createAccountWith(name: nameField.text!, email: emailField.text!, password: password) { (error) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                         self.progressView?.hideProgress()
                         self.progressView = nil
                         if let _ = error {
                            let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Sign In Failed", message: "We were unable to create an account for this email.", okButton: "OK", cancelButton: nil)
                            alert.showAlert()
                         } else {
                             let viewController = OrganizationController.createController()
                             self.navigationController?.pushViewController(viewController, animated: false)
                         }
                     }
                    }
                } else {
                    let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "Invalid Password", message: "Passwords must be at least 8 alphanumeric characters.", okButton: "OK", cancelButton: nil)
                    alert.showAlert()
                }
            } else {
                let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "Empty Fields", message: "All fields must be filled out before continuing.", okButton: "OK", cancelButton: nil)
                alert.showAlert()
            }
    }

    @objc func screenTapped(_ sender: AnyObject) {
        view.endEditing(true)
        resetTopConstraint()
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

    private func resetTopConstraint() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundTopConstraint.constant = 27
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension CreateAccountController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        var constraintConstant: CGFloat = 27
        if textField == nameField {
            constraintConstant = 0
        }
        else if textField == emailField {
            constraintConstant = -100
        }
        else if textField == passwordField {
            constraintConstant = -150
        }
        UIView.animate(withDuration: 0.2) {
            self.backgroundTopConstraint.constant = constraintConstant
            self.view.layoutIfNeeded()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            textField.resignFirstResponder()
            resetTopConstraint()
        }
        return true
    }
    
}
