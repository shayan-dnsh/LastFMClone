//
//  TrackDetailRemoteDetaSource.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Foundation

/// `TrackDetailRemoteDataSource` data source for get track detail via API
protocol TrackDetailRemoteDataSource {
    func getTrackDetail(trackDetailParameterDTO: TrackDetailParameterDTO) -> Observable<TrackDetail>
}


struct TrackDetailRemoteDataSourceImpl: TrackDetailRemoteDataSource {
    
    func getTrackDetail(trackDetailParameterDTO: TrackDetailParameterDTO)
    -> Observable<TrackDetail> {
        
        let input = API.TrackDetailInput(dto: trackDetailParameterDTO)
        
        return API.shared.getTrackDetail(input)
            .map { (output) -> TrackDetail in
                let trackDetail = TrackDetail(trackItem: output.track)
                return trackDetail
            }
            .eraseToAnyPublisher()
    }
}
