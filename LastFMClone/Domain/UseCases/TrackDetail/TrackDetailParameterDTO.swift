//
//  TrackDetailParameterDTO.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//


/// `TrackDetailParameterDTO` Input parameter for track services

struct TrackDetailParameterDTO {
    var usingCache = false
    var track = ""
    var artist = ""
    let apiKey = "44c76de454c8b512fcff34f23964cce7"
    let sharedSecret = "e382088e2c8a0e2c69268c0a26b5bf7d"
}
