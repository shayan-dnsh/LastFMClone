//
//  SearchTrackModel.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import Foundation

import Foundation

// MARK: - SearchTrackModel
struct SearchTrackModel: Codable, Equatable {
    let results: Results?
}

// MARK: - Results
struct Results: Codable, Equatable  {
    let trackmatches: Trackmatches?

}

// MARK: - Trackmatches
struct Trackmatches: Codable, Equatable  {
    let track: [SearchItemTrack]?
}

// MARK: - Track
struct SearchItemTrack: Codable, Equatable {
    let name, artist: String?
    let url: String?
    let listeners: String?
    let image: [TrackImage]?
    let mbid: String?
}
