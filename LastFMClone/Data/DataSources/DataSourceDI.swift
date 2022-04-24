//
//  DataSourceServiceLocator.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Foundation

/// `DataSourceDI` Service Locator for data sources
protocol DataSourceDI {
    func resolve() -> UserTrackRemoteDataSource
    func resolve() -> UserTrackLocalDataSource
    func resolve() -> SearchTrackRemoteDataSource
    func resolve() -> TrackDetailRemoteDataSource
    func resolve() -> TrackDetailLocalDataSource
}

extension DataSourceDI where Self: BaseDI {
    func resolve() -> UserTrackRemoteDataSource {
        UserTrackRemoteDataSourceIMPL()
    }
    
    func resolve() -> UserTrackLocalDataSource {
        UserTrackLocalDataSourceIMPL(storage: resolve())
    }
    
    func resolve() -> SearchTrackRemoteDataSource {
        SearchTrackRemoteDataSourceImpl()
    }
    
    func resolve() -> TrackDetailRemoteDataSource {
        TrackDetailRemoteDataSourceImpl()
    }
    
    func resolve() -> TrackDetailLocalDataSource {
        TrackDetailLocalDataSourceImpl(storage: resolve())
    }
}

