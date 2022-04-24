//
//  UserTrack.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/7/21.
//

import Foundation

// MARK: - UserTrack
struct UserTrack: Equatable {
    var streamable: Streamable?
    var mbid, name: String?
    var image: [TrackImage]?
    var artist: Artist?
    var url: String?
    var duration: String?
    var playcount: String?
    var listeners: String?
    var isFavorited: Bool?
    
    init(model: Track?) {
        self.streamable = model?.streamable
        self.mbid = model?.mbid
        self.name = model?.name
        self.image = model?.image
        self.artist = model?.artist
        self.url = model?.url
        self.duration = model?.duration
        self.playcount = model?.playcount
        self.listeners = nil
    }
    
    init(searchModel: SearchItemTrack?) {
        
        self.mbid = searchModel?.mbid
        self.name = searchModel?.name
        self.image = searchModel?.image
        self.artist = Artist(url: nil, name: searchModel?.artist, mbid: nil)
        self.url = searchModel?.url
        self.listeners = searchModel?.listeners
        self.duration = nil
        self.streamable = nil
        self.playcount = nil
    }
    
    init() {
        self.init(model: nil)
    }
    
    
}



