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

    var progressView: ProgressView!
    var event: Event!

    // MARK: - Init

    static func createControllerFor(event: Event) ->  EntrantController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: EntrantController = storyboard.instantiateViewController(withIdentifier: EntrantControllerId) as! EntrantController
        viewController.event = event
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
    }

    // MARK: - Actions

    @IBAction func enterTapped(_ sender:AnyObject) {
        if firstNameField.isNilOrEmpty() == false && lastNameField.isNilOrEmpty() == false && emailField.isNilOrEmpty() == false && phoneField.isNilOrEmpty() == false {
            if phoneField.text!.count == 10 && phoneField.text!.isNumber() == true {
                progressView = ProgressView.createProgressFor(parentController: navigationController!, title: "Entering Contest")
                progressView.showProgress()
                resetTopConstraint()
                event.addEntrantWith(firstName: firstNameField.text!, lastName: lastNameField.text!, email: emailField.text!, phone: phoneField.text!) { [unowned self] (error) in
                    DispatchQueue.main.async {
                        self.progressView.hideProgress()
                        if let _ = error {
                            let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Entree Error", message: "An error occurred while entering contest.", okButton: "OK", cancelButton: nil)
                            alert.showAlert()
                        } else {
                            let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Congratulations", message: "You've been entered into the contest!", okButton: "OK", cancelButton: nil)
                            alert.delegate = self
                            alert.showAlert()
                        }
                    }
                }
            } else {
                let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "Invalid Phone Number", message: "Phone numbers must be 10 digits.", okButton: "OK", cancelButton: nil)
                alert.showAlert()
            }
        } else {
            let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "Empty Fields", message: "All fields must be filled out before entering.", okButton: "OK", cancelButton: nil)
            alert.showAlert()
        }
    }

    @objc func screenTapped(_ sender: AnyObject) {
        view.endEditing(true)
        resetTopConstraint()
    }

    @objc func closeTapped(_ sender: AnyObject) {
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
        let alert = TextAlertView.createAlertFor(parentController: navigationController!, title: "Password required to close", placeholder: "Password", okButton: "OK", cancelButton: "Cancel")
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

// MARK: - CardAlertViewDelegate

extension EntrantController: CardAlertViewDelegate {
    
    func okTappedForCardAlertView(alertView: CardAlertView) {
        firstNameField.text = ""
        lastNameField.text = ""
        emailField.text = ""
        phoneField.text = ""
        firstNameField.becomeFirstResponder()
    }
    
    func cancelTappedForCardAlertView(alertView: CardAlertView) {
        // do nothing
    }

}

// MARK: - TextAlertViewDelegate

extension EntrantController: TextAlertViewDelegate {

    func okTappedForTextAlertView(alertView: TextAlertView, text: String) {
        if Organization.encodePassword(text) == Organization.shared.password {
            navigationController?.popViewController(animated: true)
        } else {
            let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "Incorrect Password", message: "The password entered is incorrect.", okButton: "OK", cancelButton: nil)
            alert.showAlert()
        }
    }

}
