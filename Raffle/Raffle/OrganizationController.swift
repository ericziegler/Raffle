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

    // MARK: - Properties
    
    @IBOutlet var nameLabel: TitleLabel!
    @IBOutlet var eventsTable: UITableView!
    
    private let refreshControl = UIRefreshControl()
    let organization = Organization.shared
    
    // MARK: - Init

    static func createController() ->  OrganizationController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: OrganizationController = storyboard.instantiateViewController(withIdentifier: OrganizationControllerId) as! OrganizationController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome"
        eventsTable.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.appGray
        refreshControl.addTarget(self, action: #selector(refreshEvents(_:)), for: .valueChanged)
        nameLabel.text = organization.name
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    // MARK: - Actions
    
    @objc private func refreshEvents(_ sender: AnyObject) {
        refreshControl.beginRefreshing()
        organization.loadEventsWith { [unowned self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.refreshControl.endRefreshing()
                if error == nil {
                    self.eventsTable.reloadData()
                }
            }
        }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension OrganizationController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return organization.events.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCellId, for: indexPath) as! AddItemCell
            return cell
        } else {
            let event = organization.events[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: EventCellId, for: indexPath) as! EventCell
            cell.layoutFor(event: event)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return AddItemCellHeight
        } else {
            return EventCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // TODO: Add event
        } else {
            let event = organization.events[indexPath.row]
            let viewController = EventController.createControllerFor(event: event)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
}
