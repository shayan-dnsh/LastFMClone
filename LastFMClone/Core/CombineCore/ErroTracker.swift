//
//  ErroTracker.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/7/21.
//

import Combine

/// Each ``PassthroughSubject`` that need to track errors can use bellow extension and  ``  ErrorTracker `` typealies
public typealias ErrorTracker = PassthroughSubject<AppError, Never>


extension Publisher where Failure: Error {
    
    /// - Returns  `AnyPublisher` with `Failure` and `OutPut` event. But just `Failure` is userd
    /// - Parameter errorTracker: A PassthroughSubject of `ErrorTracker` type to bind from subscriber
    public func trackError(_ errorTracker: ErrorTracker) -> AnyPublisher<Output, Failure> {
        
        return handleEvents(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                errorTracker.send( AppError.map(error) )
            }
        }).eraseToAnyPublisher()
    }
}


