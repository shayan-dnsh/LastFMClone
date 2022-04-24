//
//  GetUserTrackUseCaseProxy.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/12/21.
//

import Foundation


/// `GetUserTracksUseCase` UseCase proxy to get user tracks
protocol GetUserTracksUseCase {
    func getUserTracks() -> Observable<[UserTrack]>
}

struct GetUserTracks: GetUserTracksUseCase, GetUserTracksType {
    var di: DependencyInjection {
        BaseDI()
    }
    
    var tracksRepositroy: UserTrackRepository {
        return di.resolve()
    }
    
    func getUserTracks() -> Observable<[UserTrack]> {
        let inputParameter = InputParameterDTO()
        return getUserStoredUserTracks(inputParamDTO: inputParameter)
    }
}
