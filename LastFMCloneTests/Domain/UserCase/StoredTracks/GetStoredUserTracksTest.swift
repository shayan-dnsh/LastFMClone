//
//  StoredUserTrackTest.swift
//  LastFMCloneTests
//
//  Created by shayan amindaneshpour on 10/9/21.
//


@testable import LastFMClone
import XCTest

/**
 This is test for get user tracks from repository
 When we wanna develop the project we can use unit tests make it red and then green and finally refactor the code
 In this project we write test for one state and it can be expanded to whole project.
 */

final class GetStoredUserTrackTest: XCTestCase {
    
    
    var tracksRepositroy: UserTrackRepository {
      return trackRepositoryMock
    }
    
    private var trackRepositoryMock = UserTrackRepositoryMock(localDataSource: UserTrackLocalDataSourceMockImpl())
    
    private var cancelBag: CancelBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cancelBag = CancelBag()
        
    }
    
    override func tearDownWithError() throws {
        cancelBag.cancel()
        cancelBag = nil
        try super.tearDownWithError()
    }
    
    func test_getUserTracks() {
        // given
        let inputParameterDTO = InputParameterDTO()
        var mockUserTracks: [UserTrack] = []
        var userTrack1 = UserTrack()
        userTrack1.name = "Bohemien"
        
        var userTrack2 = UserTrack()
        userTrack2.name = "Radio Gaga"
        
        let validSource: [UserTrack] = [userTrack1, userTrack2]
        
        
        let publisher = tracksRepositroy.getUserStoredUserTracks(inputParamDTO: inputParameterDTO)
        let result = expectValue(of: publisher, equals: [{ output in
            mockUserTracks = output
            return true
        }])
        
        // when
        wait(for: [result.expectation], timeout: 1)
        
        // then
        XCTAssertEqual(mockUserTracks, validSource)
        
    }
    
    func test_getUserTracks_failed() {
        // given
        let inputParameterDTO = InputParameterDTO()
        trackRepositoryMock.localDataSource.storedUserTrackReturnValue = .failure(AppError.cacheError(cacheFailure: CacheFailure(description: "Failure")))
        
        let result = expectFailure(of: tracksRepositroy.getUserStoredUserTracks(inputParamDTO: inputParameterDTO))
        
        // when
        wait(for: [result.expectation], timeout: 1)
        
    }

}

