//
//  SearchTracksUseCaseProxy.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import Foundation

/// `SearchTrackUseCase` Search usecase proxy to get data from search repository
protocol SearchTrackUseCase {
    func searchUserTracks(page: Int, term: String) -> Observable<PagingInfo<UserTrack>>
}

struct SearchTrack: SearchTrackUseCase, SearchTrackType {
    var di: DependencyInjection {
        BaseDI()
    }
    
    var searchRepositroy: SearchTrackRepository {
        return di.resolve()
    }
    
    func searchUserTracks(page: Int, term: String) -> Observable<PagingInfo<UserTrack>> {
        let dto = SearchParameterDTO(page: page, perPage: 30, usingCache: false, term: term)
        return searchUserTracks(searchParamDTO: dto)
    }
}
