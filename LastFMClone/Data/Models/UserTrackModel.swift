//
//  UserTrakModel.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/12/21.
//

import Foundation

// MARK: - UserTrackModel
struct UserTrackModel: Codable, Equatable {
    let toptracks: Toptracks?
}

// MARK: - Toptracks
struct Toptracks: Codable, Equatable {
    let track: [Track]?
    let attr: ToptracksAttr?

    enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

// MARK: - ToptracksAttr
struct ToptracksAttr: Codable, Equatable {
    let user, totalPages, page, perPage: String?
    let total: String?
}

// MARK: - Track
struct Track: Codable, Equatable {
    let streamable: Streamable?
    let mbid, name: String?
    let image: [TrackImage]?
    let artist: Artist?
    let url: String?
    let duration: String?
    let attr: TrackAttr?
    let playcount: String?

    enum CodingKeys: String, CodingKey {
        case streamable, mbid, name, image, artist, url, duration
        case attr = "@attr"
        case playcount
    }
}

// MARK: - Artist
struct Artist: Codable, Equatable {
    let url: String?
    let name, mbid: String?
}

// MARK: - TrackAttr
struct TrackAttr: Codable, Equatable {
    let rank: String?
}

// MARK: - Image
struct TrackImage: Codable, Equatable {
    let size: Size?
    let text: String?

    enum CodingKeys: String, CodingKey {
        case size
        case text = "#text"
    }
}

enum Size: String, Codable {
    case extralarge = "extralarge"
    case large = "large"
    case medium = "medium"
    case small = "small"
}

// MARK: - Streamable
struct Streamable: Codable, Equatable {
    let fulltrack, text: String?

    enum CodingKeys: String, CodingKey {
        case fulltrack
        case text = "#text"
    }
}

