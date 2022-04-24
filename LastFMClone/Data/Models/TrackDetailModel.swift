//
//  TrackDetailModel.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Foundation

// MARK: - TrackDetailModel
struct TrackDetailModel: Codable, Equatable {
    let track: TrackItemDetail?
}

// MARK: - Track
struct TrackItemDetail: Codable, Equatable {
    let name: String?
    let url: String?
    let duration: String?
    let listeners, playcount: String?
    let artist: Artist?
    let album: Album?
    let toptags: Toptags?
    let wiki: Wiki?
}

// MARK: - Album
struct Album: Codable, Equatable {
    let artist, title: String?
    let url: String?
    let image: [TrackImage]?
}

// MARK: - Toptags
struct Toptags: Codable, Equatable {
    let tag: [Tag]?
}

// MARK: - Tag
struct Tag: Codable, Equatable {
    let name: String?
    let url: String?
}

// MARK: - Wiki
struct Wiki: Codable, Equatable {
    let published, summary, content: String?
}

