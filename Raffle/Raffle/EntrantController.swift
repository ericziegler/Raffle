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

    // MARK: - Init

    static func createController() ->  EntrantController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: EntrantController = storyboard.instantiateViewController(withIdentifier: EntrantControllerId) as! EntrantController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Enter Contest"
    }

}
