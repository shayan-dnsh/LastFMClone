//
//  APP+XCTestCase.swift
//  LastFMCloneTests
//
//  Created by shayan amindaneshpour on 10/10/21.
//

import XCTest
import Combine

/**
 This file contain handy tools for create unit test with Combine and make it easy to write test. 
 */

extension XCTestCase {
    func wait(interval: TimeInterval = 0.1, completion: @escaping (() -> Void)) {
        let promise = expectation(description: "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            completion()
            promise.fulfill()
        }
        
        /// This 0.1 is a guarantee that bellow line will execute after asyncAfter
        waitForExpectations(timeout: interval + 0.1)
    }
    
}

extension XCTestCase {
    typealias CompletionResult = (expectation: XCTestExpectation, cancellable: AnyCancellable, file: StaticString, line: UInt)
    
    func expectCompletion<T: Publisher>(of publisher: T,
                                        timeout: TimeInterval = 10,
                                        file: StaticString = #file,
                                        line: UInt = #line) -> CompletionResult {
        // Given
        let promise = expectation(description: "Successful completion of " + String(describing: publisher))
        
        // when
        let cancellable = publisher
            .sink(receiveCompletion: { completion in
                if case .finished = completion {
                    promise.fulfill()
                }
            }, receiveValue: { _ in })
        

        return (promise, cancellable, file, line)
    }
    
    func expectFailure<T: Publisher>(of publisher: T,
                                     timeout: TimeInterval = 10,
                                     file: StaticString = #file,
                                     line: UInt = #line) -> CompletionResult {
        // Given
        let promise = expectation(description: "Failure completion of " + String(describing: publisher))
        
        // when
        let cancellable = publisher
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    promise.fulfill()
                }
            }, receiveValue: { _ in })
        
        return (promise, cancellable, file, line)
    }
    
    func expectValue<T: Publisher>(of publisher: T,
                                   timeout: TimeInterval = 10,
                                   file: StaticString = #file,
                                   line: UInt = #line,
                                   equals: [(T.Output) -> Bool]) -> CompletionResult {
        // Given
        let promise = expectation(description: "Correct values of " + String(describing: publisher))
        var mutableEquals = equals
        
        // when
        let cancellable = publisher
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    print("value is \(value)")
                    if mutableEquals.first?(value) ?? false {
                        _ = mutableEquals.remove(at: 0)
                        if mutableEquals.isEmpty {
                            promise.fulfill()
                        }
                    }
                  })
        
        return (promise, cancellable, file, line)
    }
    
    
}
