//
//  Driver.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/7/21.
//

import Foundation
import Combine

/// Each ``AnyPublisher`` that just trigger something can use bellow extension and  ``  Driver `` typealies
public typealias Driver<T> = AnyPublisher<T, Never>

extension Publisher {
    
    /// Function `asDriver` return the  AnyPublisher with type `Driver` and  there is no error defined on it.
    /// Defined execute on main thread with `RunLoop.main`
    public func asDriver() -> Driver<Output> {
        return self.catch { _ in Empty() }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    public static func just(_ output: Output) -> Driver<Output> {
        return Just(output).eraseToAnyPublisher()
    }
    
    
    /// The  empty AnyPublisher with easy to use `Empty`
    public static func empty() -> Driver<Output> {
        return Empty().eraseToAnyPublisher()
    }
    
}
