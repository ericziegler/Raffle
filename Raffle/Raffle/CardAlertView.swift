//
//  CardAlertView.swift
//  Raffle
//
//  Created by Eric on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let CardAlertViewTopConstraintConstant: CGFloat = 105
let CardAlertViewDarkAnimateInterval: TimeInterval = 0.15
let CardAlertViewLightAnimateInterval: TimeInterval = 0.2

// MARK: - Protocols

protocol CardAlertViewDelegate {
    func okTappedForCardAlertView(alertView: CardAlertView)
    func cancelTappedForCardAlertView(alertView: CardAlertView)
}

// MARK: - Enums

enum CardAlertStatus {
    case neutral
    case ok
    case cancel
}

class CardAlertView: UIView {

    // MARK: - Properties

    @IBOutlet var bgView: UIView!
    @IBOutlet var alertViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabel: BoldLabel!
    @IBOutlet var messageLabel: RegularLabel!
    @IBOutlet var okButton: BoldButton!
    @IBOutlet var cancelButton: BoldButton!
    @IBOutlet var singleButton: BoldButton!

    var selectionStatus = CardAlertStatus.neutral
    var delegate: CardAlertViewDelegate?

    // MARK: - Init

    class func createAlertFor(parentController: UIViewController, title: String?, message: String?, okButton: String, cancelButton: String?) -> CardAlertView {
        let alert: CardAlertView = UIView.fromNib()
        alert.fillInParentView(parentView: parentController.view)
        alert.titleLabel.text = title
        alert.messageLabel.text = message
        alert.messageLabel.sizeToFit()
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
            }
        }
    }

    func hideAlert() {
        UIView.animate(withDuration: CardAlertViewDarkAnimateInterval, animations: {
            self.alpha = 0
        }) { (didFinish) in
            self.removeFromSuperview()
            if self.selectionStatus == .ok {
                self.delegate?.okTappedForCardAlertView(alertView: self)
            } else {
                self.delegate?.cancelTappedForCardAlertView(alertView: self)
            }
        }
    }

    // MARK: - Actions

    @IBAction func okTapped(_ sender: AnyObject) {
        selectionStatus = .ok
        hideAlert()
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        selectionStatus = .cancel
        hideAlert()
    }

}

