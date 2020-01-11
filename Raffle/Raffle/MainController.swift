//
//  ViewController.swift
//  Raffle
//
//  Created by Eric Ziegler on 1/9/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

class MainController: BaseViewController {

    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Actions
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        let viewController = SignInController.createController()
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func createAccountTapped(_ sender: AnyObject) {
        let viewController = CreateAccountController.createController()
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

