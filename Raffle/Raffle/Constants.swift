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
let ImportCSVInstructions = "Attached are the entrants for your event. To import them into Excel, follow these steps:\n\n1. In Excel, navigate to the 'Data' tab.\n2. Select 'From Text'.\n3. Select the csv file attachment that you've saved.\n4. Select 'Import'.\n5. In Wizard Step 1 of 3, select 'Delimited' and select 'Next'.\n6. In Wizard Step 2 of 3, check 'Comma' and select 'Next'.\n7. In Wizard Step 3 of 3, select 'Finish'."
    
typealias RequestCompletionBlock = (_ error: Error?) -> ()
typealias RequestCheckEmailBlock = (_ matchCount: Int, _ error: Error?) -> ()

enum RaffleError: Error {

    case UnexpectedResult
    case JSONParsing
    case InvalidRequest
    case Unknown

}
