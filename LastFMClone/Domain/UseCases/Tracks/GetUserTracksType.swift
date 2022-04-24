//
//  GetStoredUserTracks.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/7/21.
//

import Combine

/// `GetUserTracksType` UseCase to get user tracks
protocol GetUserTracksType {
    var tracksRepositroy: UserTrackRepository { get }
}

extension GetUserTracksType {
    func getUserStoredUserTracks(inputParamDTO: InputParameterDTO) -> Observable<[UserTrack]> {
        tracksRepositroy.getUserStoredUserTracks(inputParamDTO: inputParamDTO)
    }
    
    func getUserStoredUserTracks() -> Observable<[UserTrack]> {
        tracksRepositroy.getUserStoredUserTracks()
    }
}

