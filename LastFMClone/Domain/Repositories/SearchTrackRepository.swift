//
//  SearchTrackRepository.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import Foundation
import Combine

/// `SearchTrackRepository` The repository get search result of tracks
protocol SearchTrackRepository {
    func searchTrack(searchParamDTO: SearchParameterDTO) -> Observable<PagingInfo<UserTrack>>
}
