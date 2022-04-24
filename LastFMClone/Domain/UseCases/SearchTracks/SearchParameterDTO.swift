//
//  SearchParameterDTO.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

/// `SearchParameterDTO` Input parameter for search service 
struct SearchParameterDTO {
    var page = 1
    var perPage = 30
    var usingCache = false
    var term = ""
    let apiKey = "44c76de454c8b512fcff34f23964cce7"
    let sharedSecret = "e382088e2c8a0e2c69268c0a26b5bf7d"
}
