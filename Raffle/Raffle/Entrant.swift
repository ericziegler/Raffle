//
//  Entrant.swift
//  Raffle
//
//  Created by Eric on 1/11/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import Foundation

class Entrant {

    // MARK: - Properties
    
    var identifier = ""
    var firstName = ""
    var lastName = ""
    var email = ""
    var phone = ""

    // MARK: - Loading

    func load(props: JSON) {
        identifier = props.dictionary!["id"]!.stringValue        
        firstName = props.dictionary!["first_name"]!.stringValue
        lastName = props.dictionary!["last_name"]!.stringValue
        email = props.dictionary!["email"]!.stringValue
        phone = props.dictionary!["phone"]!.stringValue
    }

    // MARK: - Formatting

    var formattedName: String {
        return "\(firstName) \(lastName)"
    }

    var formattedPhone: String {
        if let result = String.formatPhoneNumber(source: phone) {
            return result
        }
        return ""
    }
    
}
