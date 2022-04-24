//
//  SearchTrackType.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import Combine


/// `SearchTrackType` UseCase for search tracks
protocol SearchTrackType {
    var searchRepositroy: SearchTrackRepository { get }
}

extension SearchTrackType {
    func searchUserTracks(searchParamDTO: SearchParameterDTO) -> Observable<PagingInfo<UserTrack>> {
        searchRepositroy.searchTrack(searchParamDTO: searchParamDTO)
    }
}
