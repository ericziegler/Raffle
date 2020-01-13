//
//  EventController.swift
//  Raffle
//
//  Created by Eric Ziegler on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let EventControllerId = "EventControllerId"

class EventController: BaseViewController {

    // MARK: - Properties
    
    var event: Event!
    
    // MARK: - Init

    static func createControllerFor(event: Event) ->  EventController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: EventController = storyboard.instantiateViewController(withIdentifier: EventControllerId) as! EventController
        viewController.event = event
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Event"
        navigationItem.setHidesBackButton(false, animated: false)
    }

}
