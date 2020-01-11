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
    
    
    // MARK: - Init
    
    static func createController() -> SignInController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: SignInController = storyboard.instantiateViewController(withIdentifier: SignInControllerId) as! SignInController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign In"
    }
    
}
