//
//  UserTrackRepositoryTEst.swift
//  LastFMCloneTests
//
//  Created by shayan amindaneshpour on 10/9/21.
//


@testable import LastFMClone
import Combine

struct UserTrackRepositoryMock: UserTrackRepository {
      
    var localDataSource: UserTrackLocalDataSourceMockImpl
    
    init(localDataSource: UserTrackLocalDataSourceMockImpl) {
        self.localDataSource = localDataSource
    }
    
    func getUserStoredUserTracks(inputParamDTO: InputParameterDTO) -> Observable<[UserTrack]> {
        return localDataSource.getCachedUserTracks()
    }
    
    
}

