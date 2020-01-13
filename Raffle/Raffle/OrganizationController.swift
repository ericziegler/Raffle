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
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped(_:)))
        navigationItem.rightBarButtonItem = logoutButton
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

    @objc func logoutTapped(_ sender: AnyObject) {
        promptForPassword()
    }

    // MARK: - Helpers

    private func promptForPassword() {
        let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "Logout", message: "Are you sure you want to logout?", okButton: "Logout", cancelButton: "Cancel")
        alert.delegate = self
        alert.showAlert()
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
            return organization.sortedEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCellId, for: indexPath) as! AddItemCell
            return cell
        } else {
            let event = organization.sortedEvents[indexPath.row]
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
            let alert = TextAlertView.createAlertFor(parentController: navigationController!, title: "Add a New Event", placeholder: "Event Name", okButton: "Add", cancelButton: "Cancel")
            alert.delegate = self
            alert.showAlert()
        } else {
            let event = organization.sortedEvents[indexPath.row]
            let viewController = EventController.createControllerFor(event: event)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
}

// MARK: - TextAlertViewDelegate

extension OrganizationController: TextAlertViewDelegate {

    func okTappedForTextAlertView(alertView: TextAlertView, text: String) {
        organization.addEventWith(name: text) { [unowned self] (error) in
            DispatchQueue.main.async {
                if let _ = error {
                    let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Couldn't Add Event", message: "We were unable to add this event.", okButton: "OK", cancelButton: nil)
                    alert.showAlert()
                } else {
                    self.eventsTable.reloadData()
                }
            }
        }
    }
    
}

// MARK: - CardAlertViewDelegate

extension OrganizationController: CardAlertViewDelegate {
    func okTappedForCardAlertView(alertView: CardAlertView) {
        Organization.shared.logout()
        navigationController?.popToRootViewController(animated: true)
    }

    func cancelTappedForCardAlertView(alertView: CardAlertView) {
        // do nothing
    }

}
