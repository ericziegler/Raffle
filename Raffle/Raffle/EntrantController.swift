//
//  EntrantController.swift
//  Raffle
//
//  Created by Eric Ziegler on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let EntrantControllerId = "EntrantControllerId"

class EntrantController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var firstNameField: StyledTextField!
    @IBOutlet var lastNameField: StyledTextField!
    @IBOutlet var emailField: StyledTextField!
    @IBOutlet var phoneField: StyledTextField!
    @IBOutlet var textFieldBackground: UIView!
    @IBOutlet var backgroundTopConstraint: NSLayoutConstraint!

    var loggingOut = false

    // MARK: - Init

    static func createController() ->  EntrantController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: EntrantController = storyboard.instantiateViewController(withIdentifier: EntrantControllerId) as! EntrantController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Enter Contest"
        textFieldBackground.layer.cornerRadius = 10
        textFieldBackground.layer.borderColor = UIColor(hex: 0xdddddd).cgColor
        textFieldBackground.layer.borderWidth = 1.5
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped(_:)))
        view.addGestureRecognizer(tapRecognizer)

         // Disable the swipe to make sure you get your chance to save
        navigationController!.interactivePopGestureRecognizer?.isEnabled = false
         // Replace the default back button
        navigationItem.setHidesBackButton(true, animated: false)
        let backButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped(_:)))
        navigationItem.leftBarButtonItem = backButton

        let logoutButton = UIBarButtonItem(title: "Admin Logout", style: .plain, target: self, action: #selector(logoutTapped(_:)))
        navigationItem.rightBarButtonItem = logoutButton
    }

    // MARK: - Actions

    @IBAction func enterTapped(_ sender:AnyObject) {
        print("ENTER TAPPED")
    }

    @objc func screenTapped(_ sender: AnyObject) {
        view.endEditing(true)
        resetTopConstraint()
    }

    @objc func closeTapped(_ sender: AnyObject) {
        loggingOut = false
        promptForPassword()
    }

    @objc func logoutTapped(_ sender: AnyObject) {
        loggingOut = true
        promptForPassword()
    }

    // MARK: - Helpers

    private func resetTopConstraint() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundTopConstraint.constant = 17
            self.view.layoutIfNeeded()
        }
    }

    private func promptForPassword() {
        let title = (loggingOut == true) ? "Password required to logout" : "Password required to close"
        let alert = TextAlertView.createAlertFor(parentController: navigationController!, title: title, placeholder: "Password", okButton: "OK", cancelButton: "Cancel")
        alert.entryField.keyboardType = .default
        alert.entryField.isSecureTextEntry = true
        alert.delegate = self
        alert.showAlert()
    }

}

// MARK: - UITextFieldDelegate

extension EntrantController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        var constraintConstant: CGFloat = 17
        if textField == firstNameField {
            constraintConstant = 0
        }
        else if textField == lastNameField {
            constraintConstant = -100
        }
        else if textField == emailField {
            constraintConstant = -150
        }
        else if textField == phoneField {
            constraintConstant = -200
        }
        UIView.animate(withDuration: 0.2) {
            self.backgroundTopConstraint.constant = constraintConstant
            self.view.layoutIfNeeded()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        }
        else if textField == lastNameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            phoneField.becomeFirstResponder()
        }
        else if textField ==  phoneField {
            textField.resignFirstResponder()
            resetTopConstraint()
        }
        return true
    }

}

// MARK: - TextAlertViewDelegate

extension EntrantController: TextAlertViewDelegate {

    func okTappedForTextAlertView(alertView: TextAlertView, text: String) {
        if Organization.encodePassword(text) == Organization.shared.password {
            if loggingOut == true {
                Organization.shared.logout()
                navigationController?.popToRootViewController(animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
        } else {
            let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "Incorrect Password", message: "The password entered is incorrect.", okButton: "OK", cancelButton: nil)
            alert.showAlert()
        }
        loggingOut = false
    }

}
