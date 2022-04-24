//
//  Observable.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/7/21.
//

import Combine

/// Each ``AnyPublisher`` that need to observed can use bellow extension and  ``  Observable `` typealies
public typealias Observable<T> = AnyPublisher<T, AppError>

extension Publisher {
    
    /// Function `asObservable` return the  AnyPublisher with type `Observable` and  with error maping.
    public func asObservable() -> Observable<Output> {
        self.mapError { AppError.map($0) }
            .eraseToAnyPublisher()
    }
    
    public static func just(_ output: Output) -> Observable<Output> {
        Just(output)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: TODO: Give it more description
    /// The  empty AnyPublisher with easy to use `Empty`
    public static func empty() -> Observable<Output> {
        return Empty().eraseToAnyPublisher()
    }
    
    
}
