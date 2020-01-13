//
//  AddItemCell.swift
//  Raffle
//
//  Created by Eric Ziegler on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let AddItemCellId = "AddItemCellId"
let AddItemCellHeight: CGFloat = 75

class AddItemCell: UITableViewCell {
    
    @IBOutlet var bgView: UIView!

    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 8
        bgView.layer.borderWidth = 2.5
        bgView.layer.borderColor = UIColor.secondary.cgColor
    }

}
