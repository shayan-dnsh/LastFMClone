//
//  Publisher+Swift.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/8/21.
//

import Combine

/// Sink helper function to suscribe an publisher
extension Publisher {
    public func sink() -> AnyCancellable {
        return self.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}
