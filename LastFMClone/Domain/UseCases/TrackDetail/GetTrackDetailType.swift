//
//  TrackDetailType.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Combine

/// `GetTrackDetailType` UseCase for get track detail
protocol GetTrackDetailType {
    var mediaDetailRepository: MediaDetailRepository { get }
}

extension GetTrackDetailType {
    func getTrackDetail(trackDetailItemDTO: TrackDetailParameterDTO) -> Observable<TrackDetail> {
        mediaDetailRepository.getTrackDetail(trackDetailParameterDTO: trackDetailItemDTO)
    }
}
