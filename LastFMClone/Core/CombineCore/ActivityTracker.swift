//
//  ActivityTracker.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/7/21.
//

import Combine
import UIKit

/// Each ``CurrentValueSubject`` that need to use tracking subscription can use bellow extension and  `` ActivityTracker`` typealies
public typealias ActivityTracker = CurrentValueSubject<Bool, Never>

extension Publisher where Failure: Error {
    
    /// - Returns  `AnyPublisher` with `Failure` and `OutPut` event. But It send just Bool state based on completion and subscription
    /// - Parameter activityTracker: A CurrentValueSubject of `ActivityTracker` type to bind from subscriber
    public func trackActivity(_ activityTracker: ActivityTracker) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveSubscription: { _ in
            activityTracker.send(true)
            
        }, receiveCompletion: {_ in
            activityTracker.send(false)
            
        }).eraseToAnyPublisher()
    }
    
}
