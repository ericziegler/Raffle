//
//  ResetPasswordController.swift
//  Raffle
//
//  Created by Eric on 1/10/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let ResetPasswordControllerId = "ResetPasswordControllerId"

class ResetPasswordController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var emailField: StyledTextField!
    @IBOutlet var textFieldBackground: UIView!
    var progressView: ProgressView?

    // MARK: - Init
    
    static func createController() ->  ResetPasswordController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ResetPasswordController = storyboard.instantiateViewController(withIdentifier: ResetPasswordControllerId) as! ResetPasswordController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reset Password"
        textFieldBackground.layer.cornerRadius = 10
        textFieldBackground.layer.borderColor = UIColor(hex: 0xdddddd).cgColor
        textFieldBackground.layer.borderWidth = 1.5
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }

    // MARK - Actions

    @IBAction func resetTapped(_ sender: AnyObject) {
        if emailField.isNilOrEmpty() == true {
            let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "No Email Address", message: "You must enter an email address.", okButton: "OK", cancelButton: nil)
            alert.showAlert()
        } else {
            progressView = ProgressView.createProgressFor(parentController: navigationController!, title: "Processing")
            Organization.shared.resetPassword(email: emailField.text!) { (error) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.progressView?.hideProgress()
                    self.progressView = nil
                    if error == nil {
                        let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Password Reset", message: "An email has been sent with reset instructions.", okButton: "OK", cancelButton: nil)
                        alert.delegate = self
                        alert.showAlert()
                    } else {
                        let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "No Email Address", message: "You must enter an email address.", okButton: "OK", cancelButton: nil)
                        alert.showAlert()
                    }
                }
            }
        }
    }

    @objc func screenTapped(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate

extension ResetPasswordController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

// MARK: - CardAlertViewDelegate

extension ResetPasswordController: CardAlertViewDelegate {

    func okTappedForCardAlertView(alertView: CardAlertView) {
        navigationController?.popViewController(animated: true)
    }

    func cancelTappedForCardAlertView(alertView: CardAlertView) {

    }

}
