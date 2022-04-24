//
//  TrackDetail.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Foundation

/**
This is an struct to map data model of tracks to domain layer entirty of track
 */

struct TrackDetail: Equatable {
    var name: String?
    var url: String?
    var duration: String?
    var listeners, playcount: String?
    var artist: Artist?
    var album: Album?
    var toptags: Toptags?
    var wiki: Wiki?
    
    init(trackItem: TrackItemDetail?) {
        self.name = trackItem?.name
        self.url = trackItem?.url
        self.duration = trackItem?.duration
        self.listeners = trackItem?.listeners
        self.playcount = trackItem?.playcount
        self.artist = trackItem?.artist
        self.album = trackItem?.album
        self.toptags = trackItem?.toptags
        self.wiki = trackItem?.wiki
    }
    
}


