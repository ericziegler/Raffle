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
    @IBOutlet var backgroundTopConstraint: NSLayoutConstraint!
    var progressView: ProgressView?
    
    // MARK: - Init
    
    static func createController() -> SignInController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SignInControllerId) as! SignInController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        textFieldBackground.layer.cornerRadius = 10
        textFieldBackground.layer.borderColor = UIColor(hex: 0xdddddd).cgColor
        textFieldBackground.layer.borderWidth = 1.5
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Actions
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        if emailField.isNilOrEmpty() == false && passwordField.isNilOrEmpty() == false, let password =  Organization.encodePassword(passwordField.text) {            
            view.endEditing(true)
            resetTopConstraint()
            progressView = ProgressView.createProgressFor(parentController: navigationController!, title: "Logging In")
            Organization.shared.loginWith(email: emailField.text!, password: password) { (error) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.progressView?.hideProgress()
                    self.progressView = nil
                    if let _ = error {
                        let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Log In Failed", message: "We were unable to log in using this email and password.", okButton: "OK", cancelButton: nil)
                        alert.showAlert()
                    } else {
                        let viewController = OrganizationController.createController()
                        self.navigationController?.pushViewController(viewController, animated: false)
                    }
                }
            }
        } else {
            let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "Empty Fields", message: "All fields must be filled out before continuing.", okButton: "OK", cancelButton: nil)
            alert.showAlert()
        }
    }
    
    @IBAction func resetPasswordTapped(_ sender: AnyObject) {
        let viewController = ResetPasswordController.createController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func screenTapped(_ sender: AnyObject) {
        view.endEditing(true)
        resetTopConstraint()
    }

    // MARK: - Helpers

    private func resetTopConstraint() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundTopConstraint.constant = 27
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension SignInController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        var constraintConstant: CGFloat = 27
        if textField == emailField {
            constraintConstant = 0
        }
        else if textField == passwordField {
            constraintConstant = -100
        }
        UIView.animate(withDuration: 0.2) {
            self.backgroundTopConstraint.constant = constraintConstant
            self.view.layoutIfNeeded()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            textField.resignFirstResponder()
            resetTopConstraint()
        }
        return true
    }
    
}
