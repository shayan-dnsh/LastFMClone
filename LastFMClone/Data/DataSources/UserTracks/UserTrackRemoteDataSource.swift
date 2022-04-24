//
//  UserTrackRemoteDataSource.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/10/21.
//

import Foundation
import Combine

/// `UserTrackRemoteDataSource` data source for get tracks via API
protocol UserTrackRemoteDataSource {
    func getUserStoredUserTracks(inputParamDTO: InputParameterDTO) -> Observable<[UserTrack]>
}

struct UserTrackRemoteDataSourceIMPL: UserTrackRemoteDataSource {
    
    func getUserStoredUserTracks(inputParamDTO: InputParameterDTO) -> Observable<[UserTrack]> {
        let input = API.GetUserTrackListInput(dto: inputParamDTO)
        return API.shared.getUserTrackList(input)
            .map { output -> [UserTrack]?  in
                let tracks = output.toptracks?.track?.map { UserTrack(model: $0) }
                return tracks
            }
            .replaceNil(with: [])
            .eraseToAnyPublisher()
    }
    
   
}

