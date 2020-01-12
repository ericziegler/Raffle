//
//  OrganizationController.swift
//  Raffle
//
//  Created by Eric Ziegler on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let OrganizationControllerId = "OrganizationControllerId"

class OrganizationController: BaseViewController {

    // MARK: - Init

    static func createController() ->  OrganizationController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: OrganizationController = storyboard.instantiateViewController(withIdentifier: OrganizationControllerId) as! OrganizationController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome"
        navigationItem.setHidesBackButton(true, animated: false)
    }

}
