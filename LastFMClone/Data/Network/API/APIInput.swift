//
//  APIInput.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Alamofire

/// `APIInput` class that defined for create network parameter
class APIInput: APIInputBase {
    override init(urlString: String,
                  parameters: Parameters?,
                  method: HTTPMethod,
                  requireAPIKey: Bool) {
        super.init(urlString: urlString,
                   parameters: parameters,
                   method: method,
                   requireAPIKey: requireAPIKey)
        self.headers = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]

    }
}
