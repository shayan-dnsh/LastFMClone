//
//  UserTrackDAO.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//

import Foundation


/// `UserTrackDAOType` Data base CRUD methods
protocol UserTrackDAOType {
    func getUserTracks() -> [UserTrack]
    func getUserTrack(trackURL: String) -> UserTrack?
    func addUserTrack(track: UserTrack, isFavorite: Bool)
    func addUserTracks(tracks: [UserTrack])
    func removeUserTrack(track: UserTrack)
    func setFavoriteTrack(track: UserTrack)
    func removeFavoriteTrack(track: UserTrack)
}
