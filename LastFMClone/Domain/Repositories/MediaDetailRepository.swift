//
//  MediaDetailRepository.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Combine


/// `MediaDetailRepository` The repository to get track detail and change favorite of track. 
protocol MediaDetailRepository {
    func getTrackDetail(trackDetailParameterDTO: TrackDetailParameterDTO) -> Observable<TrackDetail>
    func changeFavorite(track: UserTrack, favorited: Bool)
}
