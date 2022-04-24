//
//  RepositoryDI.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

/// `RepositoryDI` Service Locator for repositories
protocol RepositoryDI {
    func resolve() -> UserTrackRepository
    func resolve() -> SearchTrackRepository
    func resolve() -> MediaDetailRepository
}

extension RepositoryDI where Self: BaseDI {
    func resolve() -> UserTrackRepository {
        UserTrackRepositoryImpl(remoteDataSource: resolve(),
                                localDataSource: resolve(),
                                storage: resolve())
    }
    
    func resolve() -> SearchTrackRepository {
        SearchTrackRepositoryImpl(remoteDataSource: resolve())
    }
    
    func resolve() -> MediaDetailRepository {
        TrackDetailRepositoryImpl(remoteDataSource: resolve(),
                                  localDataSource: resolve(),
                                  storage: resolve())
    }
}
