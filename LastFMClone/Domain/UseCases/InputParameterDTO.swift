//
//  PageDTO.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/9/21.
//

import Foundation

/// `InputParameterDTO` General service parameter dto that can be used services that doen't need other kind of input parameters
struct InputParameterDTO {
    var page = 1
    var perPage = 50
    var usingCache = false
    let apiKey = "44c76de454c8b512fcff34f23964cce7"
    let sharedSecret = "e382088e2c8a0e2c69268c0a26b5bf7d"
    let userName = "shayan_amin"
}
