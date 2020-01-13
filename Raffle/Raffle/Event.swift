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
    var name = ""
    var entrants = [Entrant]()
    var timestamp: Double = 0

    // MARK: - Loading

    func load(props: JSON) {
        identifier = props.dictionary!["id"]!.stringValue
        name = props.dictionary!["name"]!.stringValue
        timestamp = props.dictionary!["timestamp"]!.doubleValue
    }

    // MARK: - Entrants

    func loadEntrantsWith(completion: @escaping RequestCompletionBlock) {
        if let request = buildRequestFor(fileName: "entrants.php", params: ["event_id" : identifier]) {
            let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
                let response = buildJSONResponse(data: data, error: error)
                if let error = response.1 {
                    completion(error)
                }
                else if let json = response.0 {
                    self.entrants.removeAll()
                    let entrantProps = json.dictionary!["entrants"]!.arrayValue
                    for curEntrantProps in entrantProps {
                        let entrant = Entrant()
                        entrant.load(props: curEntrantProps)
                        if entrant.identifier.count > 0 {
                            self.entrants.append(entrant)
                        }
                    }
                    completion(nil)
                } else {
                    completion(RaffleError.Unknown)
                }
            }
            task.resume()
        } else {
            completion(RaffleError.InvalidRequest)
        }
    }

    func addEntrantWith(firstName: String, lastName: String, email: String, phone: String, completion: @escaping RequestCompletionBlock) {
        let entrantId = UUID().uuidString
        if let request = buildRequestFor(fileName: "add_entrant.php", params: ["event_id" : identifier, "first_name" : firstName, "last_name" : lastName, "email" : email, "phone" : phone, "id" : entrantId]) {
            let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
                let response = buildJSONResponse(data: data, error: error)
                if let error = response.1 {
                    completion(error)
                }
                else if let json = response.0 {
                    if json.dictionary!["status"]?.stringValue == SuccessStatus {
                        let entrant = Entrant()
                        entrant.identifier = entrantId
                        entrant.firstName = firstName
                        entrant.lastName = lastName
                        entrant.email = email
                        entrant.phone = phone
                        self.entrants.insert(entrant, at: 0)
                        completion(nil)
                    } else {
                        completion(RaffleError.UnexpectedResult)
                    }
                } else {
                    completion(RaffleError.Unknown)
                }
            }
            task.resume()
        } else {
            completion(RaffleError.InvalidRequest)
        }
    }

    // MARK: - Formatting

    var entrantsCSV: String {
        var result = ""
        for curEntrant in entrants {
            result += curEntrant.formattedCSV
            result += "\n"
        }
        return result
    }

}
