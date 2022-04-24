//
//  StorageDI.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//


import UIKit

/// `StorageDI` Service Locator for storage
protocol StorageDI {
    func resolve() -> UserTrackDAOType
}

extension TrackDI where Self: BaseDI {
    
    func resolve() -> UserTrackDAOType {
        UserTrackDAO()
    }
}
