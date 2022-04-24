//
//  GenericSubscriber.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/8/21.
//

import Combine

/// `GenericSubscriber` Used for manage boolean states like loading for all components.
public struct GenericSubscriber<Value>: Subscriber {
    
    public var combineIdentifier = CombineIdentifier()
    
    private let _subscribing: (Value) -> Void
    
    public init<Target: AnyObject>(_ target: Target, subscribing: @escaping (Target, Value) -> Void) {
        weak var weakTarget = target
        
        self._subscribing = { value in
            if let target = weakTarget {
                subscribing(target, value)
            }
        }
    }
    
    public func receive(subscription: Subscription) {
        subscription.request(.max(1))
    }
    
    public func receive(completion: Subscribers.Completion<Never>) {
        // There is nothing to do here
    }

    public func receive(_ input: Value) -> Subscribers.Demand {
        _subscribing(input)
        return .unlimited
    }
    
}
