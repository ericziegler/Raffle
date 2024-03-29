//
//  EventController.swift
//  Raffle
//
//  Created by Eric Ziegler on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit
import MessageUI

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadEntrants()
    }

    // MARK: - Loading

    @objc private func refreshEntrants(_ sender: AnyObject) {
        loadEntrants()
    }

    private func loadEntrants(message: String = "Fetching Entrants", completion: RequestCompletionBlock? = nil) {
        progressView = ProgressView.createProgressFor(parentController: navigationController!, title: message)
        progressView!.showProgress()
        event.loadEntrantsWith { [unowned self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.progressView!.hideProgress()
                self.progressView = nil
                if let _ = error {
                    let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Fetching Error", message: "We couldn't load the list of entrants", okButton: "OK", cancelButton: nil)
                    alert.showAlert()
                    completion?(error)
                } else {
                    self.entrantsTable.reloadData()
                    self.refreshControl.endRefreshing()
                    completion?(nil)
                }
            }
        }
    }

    // MARK: - Actions

    @IBAction func pickWinnerTapped(_ sender: AnyObject) {
        loadEntrants(message: "Picking Winner") { [unowned self] (error) in
            if error == nil {
                let randomIndex = Int.random(in: 0 ..< self.event.entrants.count)
                let entrant = self.event.entrants[randomIndex]
                let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Winner!", message: "\(entrant.formattedName)\n\(entrant.email)\n\(entrant.formattedPhone)", okButton: "OK", cancelButton: nil)
                alert.showAlert()
            }
        }
        
    }
    
    @IBAction func exportTapped(_ sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() == true {
            let alert = CardAlertView.createAlertFor(parentController: navigationController!, title: "Data Format", message: "How would you like the data exported?", okButton: "Spreadsheet", cancelButton: "Text")
            alert.delegate = self
            alert.showAlert()
        } else {
            let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "No Email Found", message: "This device must be connected to an email account to export.", okButton: "OK", cancelButton: nil)
            alert.showAlert()
        }
    }

    private func exportData(_ asPlainText: Bool = false) {
        loadEntrants(message: "Preparing Export") { [unowned self] (error) in
            if error == nil {
                var entrantData = self.event.entrantsCSV
                var entrantFileName = "entrants.csv"
                var entrantFileType = ".csv"
                if asPlainText == true {
                    // get plain text
                    entrantData = self.event.entrantsPlainText
                    entrantFileName = "entrants.txt"
                    entrantFileType = ".txt"
                }
                // write string to a file
                if entrantData.writeToFile(fileName: entrantFileName) == true {
                    // mail attachment
                    let mailComposer = MFMailComposeViewController()
                    mailComposer.mailComposeDelegate = self
                    mailComposer.setToRecipients([Organization.shared.email])
                    mailComposer.setSubject("\(self.event.name) Entrants")
                    if asPlainText == true {
                        mailComposer.setMessageBody(PlainTextExportInstructions, isHTML: false)
                    } else {
                        mailComposer.setMessageBody(ImportCSVInstructions, isHTML: false)
                    }
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent(entrantFileName)
                        do {
                            let fileData = try Data(contentsOf: fileURL, options: [.alwaysMapped, .uncached])
                            mailComposer.addAttachmentData(fileData, mimeType: entrantFileType, fileName: entrantFileName)
                            DispatchQueue.main.async {
                                self.present(mailComposer, animated: true, completion: nil)
                            }
                        } catch {
                            DispatchQueue.main.async {
                                let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Export Error", message: "An error occurred while exporting data.", okButton: "OK", cancelButton: nil)
                                alert.showAlert()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Export Error", message: "An error occurred while exporting data.", okButton: "OK", cancelButton: nil)
                            alert.showAlert()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = CardAlertView.createAlertFor(parentController: self.navigationController!, title: "Export Error", message: "An error occurred while exporting data.", okButton: "OK", cancelButton: nil)
                        alert.showAlert()
                    }
                }
            }
        }
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
            let viewController = EntrantController.createControllerFor(event: event)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

}

// MARK: - CardAlertViewDelegate

extension EventController: CardAlertViewDelegate {
    func okTappedForCardAlertView(alertView: CardAlertView) {
        // user chose to export csv
        exportData()
    }

    func cancelTappedForCardAlertView(alertView: CardAlertView) {
        // user chose to export plain text
        exportData(true)
    }

}

// MARK: - MFMailComposeViewControllerDelegate

extension EventController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }

}
