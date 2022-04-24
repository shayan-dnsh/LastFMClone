//
//  ViewModel.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/7/21.
//

import Combine


/// All ViewModels should conform this protocol
public protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    // MARK: TODO give it more description
    func transform(_ input: Input, cancelBag: CancelBag) -> Output
}
