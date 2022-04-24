//
//  TrackDetailLocalDataSource.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Foundation

/// `TrackDetailLocalDataSource` data source for get track detail Locally
protocol TrackDetailLocalDataSource {
    func changeFavorite(track: UserTrack, favorited: Bool)
}

struct TrackDetailLocalDataSourceImpl: TrackDetailLocalDataSource {
    var storage: UserTrackDAOType
    
    init(storage: UserTrackDAOType) {
        self.storage = storage
    }
    
    func changeFavorite(track: UserTrack, favorited: Bool) {
        if let track = storage.getUserTrack(trackURL: track.url ?? "") {
            favorited ? storage.setFavoriteTrack(track: track)
                : storage.removeFavoriteTrack(track: track)
        } else {
            storage.addUserTrack(track: track, isFavorite: favorited)
        }
        
    }
}
