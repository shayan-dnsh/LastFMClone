//
//  TrackDetailItemViewModel.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Foundation

/// `TrackDetailItemViewModel` track detail view model item that used in sciene layer
struct TrackDetailItemViewModel: Equatable {
    var trackDetail: TrackDetail?
    
    init(trackDetail: TrackDetail) {
        self.trackDetail = trackDetail
    }
    
    init() {
        trackDetail = nil
    }
}

