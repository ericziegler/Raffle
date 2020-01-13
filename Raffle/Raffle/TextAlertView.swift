//
//  TextAlertView.swift
//  Raffle
//
//  Created by Eric on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let TextAlertViewTopConstraintConstant: CGFloat = 105
let TextAlertViewDarkAnimateInterval: TimeInterval = 0.15
let TextAlertViewLightAnimateInterval: TimeInterval = 0.2

// MARK: - Protocols

protocol TextAlertViewDelegate {
    func okTappedForCardAlertView(alertView: TextAlertView, text: String)
}

// MARK: - Enums

enum TextAlertStatus {
    case neutral
    case ok
    case cancel
}

class TextAlertView: UIView {

    // MARK: - Properties

    @IBOutlet var bgView: UIView!
    @IBOutlet var alertViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabel: BoldLabel!
    @IBOutlet var okButton: BoldButton!
    @IBOutlet var cancelButton: BoldButton!
    @IBOutlet var singleButton: BoldButton!
    @IBOutlet var entryField: StyledTextField!

    var selectionStatus = CardAlertStatus.neutral
    var delegate: TextAlertViewDelegate?

    // MARK: - Init

    class func createAlertFor(parentController: UIViewController, title: String?, placeholder: String?, okButton: String, cancelButton: String?) -> TextAlertView {
        let alert: TextAlertView = UIView.fromNib()
        alert.fillInParentView(parentView: parentController.view)
        alert.titleLabel.text = title
        alert.entryField.placeholder = placeholder
        if let cancelButton = cancelButton {
            alert.okButton.setTitle(okButton, for: .normal)
            alert.cancelButton.setTitle(cancelButton, for: .normal)
            alert.singleButton.isHidden = true
            alert.okButton.isHidden = false
            alert.cancelButton.isHidden = false
        } else {
            alert.singleButton.setTitle(okButton, for: .normal)
            alert.singleButton.isHidden = false
            alert.okButton.isHidden = true
            alert.cancelButton.isHidden = true
        }
        return alert
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 15
        showAlert()
    }

    // MARK: - Show / Hide Animations

    func showAlert() {
        self.alpha = 0
        alertViewTopConstraint.constant = 0
        UIView.animate(withDuration: CardAlertViewDarkAnimateInterval, animations: {
            self.alpha = 1
        }) { (didFinish) in
            UIView.animate(withDuration: CardAlertViewLightAnimateInterval) {
                self.alertViewTopConstraint.constant = CardAlertViewTopConstraintConstant
                self.layoutIfNeeded()
                self.entryField.becomeFirstResponder()
            }
        }
    }

    func hideAlert() {
        UIView.animate(withDuration: CardAlertViewDarkAnimateInterval, animations: {
            self.alpha = 0
        }) { (didFinish) in
            self.removeFromSuperview()
            if self.selectionStatus == .ok {
                if let entry = self.entryField.text, entry.count > 0 {
                    self.delegate?.okTappedForCardAlertView(alertView: self, text: entry)
                }
            }
        }
    }

    // MARK: - Actions

    @IBAction func okTapped(_ sender: AnyObject) {
        selectionStatus = .ok
        hideAlert()
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        hideAlert()
    }

}


