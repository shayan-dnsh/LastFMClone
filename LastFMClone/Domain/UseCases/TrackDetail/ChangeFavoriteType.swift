//
//  ChangeFavoriteType.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Foundation

/// `ChangeFavoriteType`  UseCase to change favorite
protocol ChangeFavoriteType {
    var mediaDetailRepository: MediaDetailRepository { get }
}

extension ChangeFavoriteType {
    func changeFavoriteFromRepo(track: UserTrack, favorited: Bool) {
        mediaDetailRepository.changeFavorite(track: track, favorited: favorited)
    }
}
