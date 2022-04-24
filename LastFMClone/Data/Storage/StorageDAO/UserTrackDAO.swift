//
//  UserTrackDAO.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//

import RealmSwift

/// `UserTrackDAO` Implementation of `UserTrackDAOType`
struct UserTrackDAO: UserTrackDAOType {
  
    func getUserTracks() -> [UserTrack] {
        guard let realm = try? Realm() else {
            return []
        }
        let tracks = realm.objects(UserTrackDTO.self)
        return tracks.map { $0.getUserTrack() }
    }
    
    
    func getUserTrack(trackURL: String) -> UserTrack? {
        guard let realm = try? Realm() else {
            return nil
        }
        let track = realm.object(ofType: UserTrackDTO.self, forPrimaryKey: trackURL)
        return track?.getUserTrack()
    }
    
    func addUserTrack(track: UserTrack, isFavorite: Bool) {
        guard let realm = try? Realm() else {
            return
        }
        let trackDTO = UserTrackDTO(model: track, isFavorited: isFavorite)
        
        try? realm.write({
            realm.add(trackDTO)
        })
    }
    
    func addUserTracks(tracks: [UserTrack]) {
        guard let realm = try? Realm() else {
            return
        }
        var trackDTOList: [UserTrackDTO] = []
        
        for track in tracks {
            let trackDTO = UserTrackDTO(model: track, isFavorited: false)
            trackDTOList.append(trackDTO)
        }
        
        try? realm.write({
            realm.add(trackDTOList)
        })
        
    }
    
    
    func setFavoriteTrack(track: UserTrack) {
        guard let realm = try? Realm() else {
            return
        }
        guard let trackDTO = realm.object(ofType: UserTrackDTO.self, forPrimaryKey: track.url) else {
            return
        }
        try? realm.write({
            trackDTO.isFavorite = true
        })
        
    }
    
    func removeFavoriteTrack(track: UserTrack) {
        guard let realm = try? Realm() else {
            return
        }
        if let track = realm.object(ofType: UserTrackDTO.self, forPrimaryKey: track.url) {
            try? realm.write({
                realm.delete(track)
            })
        }
        
    }
    
    func removeUserTrack(track: UserTrack) {
        guard let realm = try? Realm() else {
            return
        }
        if let track = realm.object(ofType: UserTrackDTO.self, forPrimaryKey: track.url) {
            try? realm.write({
                realm.delete(track)
            })
        }
        
    }
    
}
