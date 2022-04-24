//
//  UserTrackRepository.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/9/21.
//

import Foundation
import Combine

/// `UserTrackRepository` The repository for get user tracks
protocol UserTrackRepository {
    func getUserStoredUserTracks(inputParamDTO: InputParameterDTO) -> Observable<[UserTrack]>
    func getUserStoredUserTracks() -> Observable<[UserTrack]>
}
