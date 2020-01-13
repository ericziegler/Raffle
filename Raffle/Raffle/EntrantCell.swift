//
//  EntrantCell.swift
//  Raffle
//
//  Created by Eric Ziegler on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let EntrantCellId = "EntrantCellId"
let EntrantCellHeight: CGFloat = 100

class EntrantCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var nameLabel: BoldLabel!
    @IBOutlet var emailLabel: RegularLabel!
    @IBOutlet var phoneLabel: RegularLabel!

    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Layout

    func layoutFor(entrant: Entrant) {
        nameLabel.text = entrant.formattedName
        emailLabel.text = entrant.email
        phoneLabel.text = entrant.formattedPhone
    }

}
