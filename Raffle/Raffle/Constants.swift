//
//  Constants.swift
//  Raffle
//
//  Created by Eric Ziegler on 1/9/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import Foundation

let AppName = "Raffle"
let EncryptionKey = "9E1C3BC5E76641F6E762151247B64922"
let RaffleAPIURL = "https://zigabytesdev.com/raffle"
let SuccessStatus = "success"
let FailStatus = "fail"
let JSONNullValue = "NULL"
    
typealias RequestCompletionBlock = (_ error: Error?) -> ()
typealias RequestCheckEmailBlock = (_ matchCount: Int, _ error: Error?) -> ()

enum RaffleError: Error {

    case UnexpectedResult
    case JSONParsing
    case InvalidRequest
    case Unknown

}
