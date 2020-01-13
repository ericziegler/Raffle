//
//  EventCell.swift
//  Raffle
//
//  Created by Eric Ziegler on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let EventCellId = "EventCellId"
let EventCellHeight: CGFloat = 45

class EventCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var nameLabel: RegularLabel!
    @IBOutlet var dateLabel: LightLabel!
    @IBOutlet var entrantsLabel: RegularLabel!

    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Layout

    func layoutFor(event: Event) {
        nameLabel.text = event.name
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: event.timestamp))
        entrantsLabel.text = "\(event.entrants.count) entrants"
    }

}
