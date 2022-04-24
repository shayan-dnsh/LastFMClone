//
//  TrackItemViewModel.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/12/21.
//

import Foundation

/// `TrackItemViewModel` track view model item that used in sciene layer
struct TrackItemViewModel: Equatable {
    let userTrack: UserTrack
    
    init(userTrack: UserTrack) {
        self.userTrack = userTrack
    }
}

extension TrackItemViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(userTrack.url)
    }
}
