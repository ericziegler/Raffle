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

    // MARK: - Init
    
    static func createController() ->  ResetPasswordController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ResetPasswordController = storyboard.instantiateViewController(withIdentifier: ResetPasswordControllerId) as! ResetPasswordController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
