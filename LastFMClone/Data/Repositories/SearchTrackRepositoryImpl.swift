//
//  SearchTrackRepositoryImpl.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import Foundation

/// `SearchTrackRepositoryImpl` Implementation of `SearchTrackRepository`
struct SearchTrackRepositoryImpl: SearchTrackRepository {
    
    var remoteDataSource: SearchTrackRemoteDataSource
    
    init(remoteDataSource: SearchTrackRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func searchTrack(searchParamDTO: SearchParameterDTO) -> Observable<PagingInfo<UserTrack>> {
        remoteDataSource.searchTracks(searchParamDTO: searchParamDTO)
    }
    
    
}
