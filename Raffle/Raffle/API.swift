//
//  API.swift
//  Raffle
//
//  Created by Eric Ziegler on 1/12/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import Foundation

func buildRequestFor(fileName: String, params: [String : String]) -> URLRequest? {
    guard var urlComponents = URLComponents(string: "\(RaffleAPIURL)/\(fileName)") else {
        return nil
    }

    var queryItems = [URLQueryItem]()
    for (curKey, curValue) in params {
        queryItems.append(URLQueryItem(name: curKey, value: curValue))
    }
    urlComponents.queryItems = queryItems

    if let url = urlComponents.url {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return request
    }

    return nil
}

func buildJSONResponse(data: Data?, error: Error?) -> (JSON?, Error?) {
    var result: (JSON?, Error?)?
    if let error = error {
        result = (nil, error)
    } else {
        if let data = data {
            guard let json = try? JSON(data: data) else {
                return (nil, RaffleError.JSONParsing)
            }
            result = (json, nil)
        } else {
            result = (nil, RaffleError.JSONParsing)
        }
    }
    if let result = result {
        return result
    } else {
        return (nil, RaffleError.JSONParsing)
    }
}
