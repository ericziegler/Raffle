//
//  ProgressView.swift
//  Raffle
//
//  Created by Eric on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let ProgressViewAnimationDuration: TimeInterval = 0.15

class ProgressView: UIView {

    // MARK: - Properties

    @IBOutlet var bgView: UIView!
    @IBOutlet var titleLabel: RegularLabel!
    @IBOutlet var circularLoader: CircularLoadingView!

    // MARK: - Init

    class func createProgressFor(parentController: UIViewController, title: String?) -> ProgressView {
        let progress: ProgressView = UIView.fromNib()
        progress.fillInParentView(parentView: parentController.view)
        progress.titleLabel.text = title
        return progress
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 12
        circularLoader.spinnerLineWidth = 8
        circularLoader.spinnerDuration = 0.35
        circularLoader.spinnerStrokeColor = UIColor.main.cgColor
        showProgress()
    }

    // MARK: - Show / Hide Animations

    func showProgress() {
        self.alpha = 0
        UIView.animate(withDuration: ProgressViewAnimationDuration, animations: {
            self.alpha = 1
        }) { (didFinish) in
            self.circularLoader.animate()
        }
    }

    func hideProgress() {
        UIView.animate(withDuration: ProgressViewAnimationDuration, animations: {
            self.alpha = 0
        }) { (didFinish) in
            self.removeFromSuperview()
        }
    }

}
