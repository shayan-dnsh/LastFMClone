//
//  GetStoredUserTracksImpl.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/9/21.
//

import Combine
import Foundation

/// `UserTrackRepositoryImpl` Implementation of `UserTrackRepository` 
struct UserTrackRepositoryImpl: UserTrackRepository {
    
    let remoteDataSource: UserTrackRemoteDataSource
    let localDataSource: UserTrackLocalDataSource
    let storage: UserTrackDAOType
    
    init(remoteDataSource: UserTrackRemoteDataSource,
         localDataSource: UserTrackLocalDataSource,
         storage: UserTrackDAOType) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.storage = storage
    }
    
    func getUserStoredUserTracks(inputParamDTO: InputParameterDTO) -> Observable<[UserTrack]> {
        
        guard storage.getUserTracks().isEmpty else {
            return localDataSource.getCachedUserTracks()
        }
       
        let observable = self.remoteDataSource.getUserStoredUserTracks(inputParamDTO: inputParamDTO)
        return observable.map {
            localDataSource.saveUserTracks(tracks: $0)
        }.eraseToAnyPublisher()
    }
    
    func getUserStoredUserTracks() -> Observable<[UserTrack]> {
        return localDataSource.getCachedUserTracks()
    }
}



