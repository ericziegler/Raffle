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
    
    // MARK: - Init
    
    static func createController() -> CreateAccountController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: CreateAccountController = storyboard.instantiateViewController(withIdentifier: CreateAccountControllerId) as! CreateAccountController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Account"
    }
    
    // MARK: - Actions
    
    @IBAction func createAccountTapped(_ sender: AnyObject) {
        
    }
    
}
