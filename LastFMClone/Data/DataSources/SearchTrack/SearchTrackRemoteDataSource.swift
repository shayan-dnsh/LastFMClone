//
//  SearchTrackRemoteDataSource.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import Foundation

/// `SearchTrackRemoteDataSource` data source for getTracks from API
protocol SearchTrackRemoteDataSource {
    func searchTracks(searchParamDTO: SearchParameterDTO) -> Observable<PagingInfo<UserTrack>>
}

struct SearchTrackRemoteDataSourceImpl: SearchTrackRemoteDataSource {
    
    func searchTracks(searchParamDTO: SearchParameterDTO) -> Observable<PagingInfo<UserTrack>> {
        let input = API.SearchTrackInput(dto: searchParamDTO)
        
        return API.shared.searchTrackList(input)
            .map { (output) -> [UserTrack]? in
                let tracks = output.results?.trackmatches?.track?.map { UserTrack(searchModel: $0) }
                return tracks
            }
            .replaceNil(with: [])
            .map { PagingInfo(page: searchParamDTO.page, items: $0)}
            .eraseToAnyPublisher()
        
    }
}
