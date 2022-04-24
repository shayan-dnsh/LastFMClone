//
//  MediaDetailUseCaseProxy.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Combine

/// `GetTrackDetailUserCase` usecase proxy that used to get track detail and favorite tracks
protocol GetTrackDetailUserCase {
    func getTrackDetail(trackName: String, artistName: String) -> Observable<TrackDetail>
}

struct GetTrackDetail: GetTrackDetailUserCase, GetTrackDetailType {

    var di: DependencyInjection {
        BaseDI()
    }
    
    var mediaDetailRepository: MediaDetailRepository {
        return di.resolve()
    }
    
    func getTrackDetail(trackName: String, artistName: String) -> Observable<TrackDetail> {
        let dto = TrackDetailParameterDTO(usingCache: false, track: trackName, artist: artistName)
        
        return getTrackDetail(trackDetailItemDTO: dto)
    }
    
}

protocol ChangeFavoriteUserCase {
    func changeFavorite(track: UserTrack, favorited: Bool)
}

struct ChangeFavorite: ChangeFavoriteUserCase, ChangeFavoriteType {
    
    var di: DependencyInjection {
        BaseDI()
    }
    
    var mediaDetailRepository: MediaDetailRepository {
        return di.resolve()
    }
    
    func changeFavorite(track: UserTrack, favorited: Bool) {
        changeFavoriteFromRepo(track: track, favorited: favorited)
    }
}

