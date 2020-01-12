//
//  Event.swift
//  Raffle
//
//  Created by Eric on 1/11/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import Foundation

class Event {

    // MARK: - Properties
    
    var identifier = ""
    var organizationId = ""
    var name = ""
    var entrants = [Entrant]()
    var timestamp: Double = 0

    // MARK: - Loading

    func load(props: JSON) {
        identifier = props.dictionary!["id"]!.stringValue
        organizationId = props.dictionary!["organization_id"]!.stringValue
        name = props.dictionary!["name"]!.stringValue
        timestamp = props.dictionary!["timestamp"]!.doubleValue
    }

}
