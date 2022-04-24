//
//  DependencyInjection.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

/// `DependencyInjection` are main service locator of whole application
protocol DependencyInjection: AnyObject,
                              DataSourceDI,
                              RepositoryDI,
                              TrackDI,
                              StorageDI,
                              SearchDI,
                              CommonDI,
                              MediaDetailDI {
}

/// `BaseDI` Used class when an object wanted from service locator. 
final class BaseDI: DependencyInjection {}




