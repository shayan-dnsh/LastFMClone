//
//  Failures.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/7/21.
//

import Combine


/// `AppError` Define custom error for whole application with `cacheError` and `serverError` and `other` type
public enum AppError: AppFailures {
    case cacheError(cacheFailure: CacheFailure)
    case serverError(serverFailure: ServerFailure)
    case other(Error)
    
    static func map(_ error: Error) -> AppError {
        return (error as? AppError) ?? .other(error)
    }
}

public protocol AppFailures: Error {}

public struct ServerFailure: AppFailures {
    let statusCode: Int?
    let description: String?
}

public struct CacheFailure: AppFailures {
    let description: String?
}
