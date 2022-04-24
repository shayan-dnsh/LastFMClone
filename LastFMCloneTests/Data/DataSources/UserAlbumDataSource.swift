//
//  UserTrackDataSource.swift
//  LastFMCloneTests
//
//  Created by shayan amindaneshpour on 10/10/21.
//

@testable import LastFMClone
import Combine

protocol UserTrackLocalDataSourceMock {
    func getCachedUserTracks() -> Observable<[UserTrack]>
}

struct UserTrackLocalDataSourceMockImpl: UserTrackLocalDataSourceMock {
  
    var storedUserTrackReturnValue = Result<[UserTrack], AppError>.success(getTrackList())
    
    func getCachedUserTracks() -> Observable<[UserTrack]> {
        return storedUserTrackReturnValue.publisher.eraseToAnyPublisher()
    }
    
    static private func getTrackList() -> [UserTrack] {
        var track1 = UserTrack()
        track1.name = "Bohemien"
        var track2 = UserTrack()
        track2.name = "Radio Gaga"
        
        return [track1, track2]
        
    }
}
