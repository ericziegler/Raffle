//
//  Organization.swift
//  Raffle
//
//  Created by Eric on 1/11/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import Foundation

class Organization {

    // MARK: - Properties
    
    var identifier = ""
    var name = ""
    var email = ""
    var password = ""
    var events = [Event]()

    // MARK: - Init

    static let shared = Organization()

    // MARK: - Authentication

    private func checkAccountExistsFor(email: String, completion: @escaping RequestCheckEmailBlock) {
        if let request = buildRequestFor(fileName: "check_email.php", params: ["email" : email]) {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let response = buildJSONResponse(data: data, error: error)
                if let error = response.1 {
                    completion(0, error)
                }
                else if let json = response.0 {
                    completion(json.dictionary!["match_count"]!.intValue, nil)
                } else {
                    completion(0, RaffleError.Unknown)
                }
            }
            task.resume()
        } else {
            completion(0, RaffleError.InvalidRequest)
        }
    }

    func createAccountWith(name: String, email: String, password: String, completion: @escaping RequestCompletionBlock) {
        // first check that no account exists with that email
        checkAccountExistsFor(email: email) { (matchCount, error) in
            if error == nil {
                let organizationId = UUID().uuidString
                if let request = buildRequestFor(fileName: "create_account.php", params: ["id" : organizationId, "name" : name, "email" : email, "password" : password]) {
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        let response = buildJSONResponse(data: data, error: error)
                        if let error = response.1 {
                            completion(error)
                        }
                        else if let json = response.0 {
                            self.identifier = json.dictionary!["id"]!.stringValue
                            if self.identifier == JSONNullValue {
                                self.logout()
                                completion(RaffleError.UnexpectedResult)
                            } else {
                                self.name = json.dictionary!["name"]!.stringValue
                                self.email = json.dictionary!["email"]!.stringValue
                                self.password = json.dictionary!["password"]!.stringValue
                                self.events = [Event]()
                                completion(nil)
                            }
                        } else {
                            completion(RaffleError.Unknown)
                        }
                    }
                    task.resume()
                } else {
                    completion(RaffleError.InvalidRequest)
                }
            } else {
                completion(error)
            }
        }
    }

    func loginWith(email: String, password: String, completion: @escaping RequestCompletionBlock) {
        if let request = buildRequestFor(fileName: "login.php", params: ["email" : email, "password" : password]) {
            let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
                let response = buildJSONResponse(data: data, error: error)
                if let error = response.1 {
                    completion(error)
                }
                else if let json = response.0 {
                    self.identifier = json.dictionary!["id"]!.stringValue
                    if self.identifier == JSONNullValue {
                        self.logout()
                        completion(RaffleError.UnexpectedResult)
                    } else {
                        self.name = json.dictionary!["name"]!.stringValue
                        self.email = json.dictionary!["email"]!.stringValue
                        self.password = json.dictionary!["password"]!.stringValue
                        self.loadEventsWith { (error) in
                            completion(error)
                        }
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

    func logout() {
        self.identifier = ""
        self.name = ""
        self.email = ""
        self.password = ""
        self.events = [Event]()
    }

    // MARK: - Events

    func addEventWith(name: String, completion: @escaping RequestCompletionBlock) {
        let eventId = UUID().uuidString
        let eventTimestamp = String(Date().timeIntervalSince1970)
        if let request = buildRequestFor(fileName: "add_event.php", params: ["organization_id" : identifier, "event_name" : name, "event_id" : eventId, "timestamp" : eventTimestamp]) {
            let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
                let response = buildJSONResponse(data: data, error: error)
                if let error = response.1 {
                    completion(error)
                }
                else if let json = response.0 {
                    if json.dictionary!["status"]?.stringValue == SuccessStatus {
                        let event = Event()
                        event.identifier = eventId
                        event.name = name
                        event.timestamp = Double(eventTimestamp)!
                        self.events.insert(event, at: 0)
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

    func loadEventsWith(completion: @escaping RequestCompletionBlock) {
        if let request = buildRequestFor(fileName: "events.php", params: ["organization_id" : identifier]) {
            let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
                let response = buildJSONResponse(data: data, error: error)
                if let error = response.1 {
                    completion(error)
                }
                else if let json = response.0 {
                    self.events.removeAll()
                    let eventProps = json.dictionary!["events"]!.arrayValue
                    for curEventProps in eventProps {
                        let event = Event()
                        event.load(props: curEventProps)
                        if event.identifier.count > 0 {
                            self.events.append(event)
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

    // MARK: - Encoding

    class func encodePassword(_ password: String?) -> String? {
        var result: String?
        if let password = password {
            // first pass
            let firstPass = Data(password.utf8).base64EncodedString()
            // second pass
            result = Data(firstPass.utf8).base64EncodedString()
        }
        return result
    }
    
}
