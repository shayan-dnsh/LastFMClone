//
//  TrackDetailRepositoryImpl.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Foundation

/// `TrackDetailRepositoryImpl` Implementation of `MediaDetailRepository`
struct TrackDetailRepositoryImpl: MediaDetailRepository {
    
    var remoteDataSource: TrackDetailRemoteDataSource
    var localDataSource: TrackDetailLocalDataSource
    let storage: UserTrackDAOType
    
    init(remoteDataSource: TrackDetailRemoteDataSource,
         localDataSource: TrackDetailLocalDataSource,
         storage: UserTrackDAOType) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.storage = storage
    }
    
    func getTrackDetail(trackDetailParameterDTO: TrackDetailParameterDTO) -> Observable<TrackDetail> {
        remoteDataSource.getTrackDetail(trackDetailParameterDTO: trackDetailParameterDTO)
    }
    
    func changeFavorite(track: UserTrack, favorited: Bool) {
        localDataSource.changeFavorite(track: track, favorited: favorited)
    }
    
    func isFavorited(trackURL: String) -> Bool {
        
        return false
    }
    
}
