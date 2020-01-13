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

    @IBOutlet var entrantsTable: UITableView!
    @IBOutlet var nameLabel: TitleLabel!

    private let refreshControl = UIRefreshControl()
    var progressView: ProgressView?
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
        entrantsTable.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.appGray
        refreshControl.addTarget(self, action: #selector(refreshEntrants(_:)), for: .valueChanged)
        nameLabel.text = event.name
        navigationItem.setHidesBackButton(false, animated: false)
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped(_:)))
        navigationItem.rightBarButtonItem = logoutButton
        loadEntrants()
    }

    // MARK: - Loading

    @objc private func refreshEntrants(_ sender: AnyObject) {
        loadEntrants()
    }

    private func loadEntrants() {
        progressView = ProgressView.createProgressFor(parentController: navigationController!, title: "Fetching Entrants")
        progressView!.showProgress()
        event.loadEntrantsWith { [unowned self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.progressView!.hideProgress()
                self.progressView = nil
                if let _ = error {
                    let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Fetching Error", message: "We couldn't load the list of entrants", okButton: "OK", cancelButton: nil)
                    alert.showAlert()
                } else {
                    self.entrantsTable.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

    // MARK: - Actions

    @IBAction func exportTapped(_ sender: AnyObject) {
        // TODO: Email csv or xlsx
        print("EXPORT TAPPED")
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

extension EventController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return event.entrants.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCellId, for: indexPath) as! AddItemCell
            return cell
        } else {
            let entrant = event.entrants[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: EntrantCellId, for: indexPath) as! EntrantCell
            cell.layoutFor(entrant: entrant)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            return AddItemCellHeight
        } else {
            return EntrantCellHeight
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let viewController = EntrantController.createController()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

}

// MARK: - CardAlertViewDelegate

extension EventController: CardAlertViewDelegate {
    func okTappedForCardAlertView(alertView: CardAlertView) {
        Organization.shared.logout()
        navigationController?.popToRootViewController(animated: true)
    }

    func cancelTappedForCardAlertView(alertView: CardAlertView) {
        // do nothing
    }

}
