//
//  UserTrackLocalDataSource.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/10/21.
//

import Foundation
import Combine

/// `UserTrackLocalDataSource` data source for get tracks locally
protocol UserTrackLocalDataSource {
    func getCachedUserTracks() -> Observable<[UserTrack]>
    func saveUserTracks(tracks: [UserTrack]) -> [UserTrack]
}

struct UserTrackLocalDataSourceIMPL: UserTrackLocalDataSource {
    var storage: UserTrackDAOType
    
    init(storage: UserTrackDAOType) {
        self.storage = storage
    }
    
    func getCachedUserTracks() -> Observable<[UserTrack]> {
        
        Future<[UserTrack], AppError> {promise in
            let tracks :[UserTrack] = storage.getUserTracks()
        
            DispatchQueue.main.async {
                promise(.success(tracks))
            }
            
        }.eraseToAnyPublisher()
    }
    
    @discardableResult
    func saveUserTracks(tracks: [UserTrack]) -> [UserTrack] {
        storage.addUserTracks(tracks: tracks)
        return tracks
    }
    
    
}
