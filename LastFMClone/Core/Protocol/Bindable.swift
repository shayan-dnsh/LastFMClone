//
//  Bindable.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//

import UIKit


/// `Bindable` Protocol use in viewcontroller that have view model to bind view model and put their tirggers
public protocol Bindable: AnyObject {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType? { get set }
    
    func bindViewModel()
}

extension Bindable where Self: UIViewController {
    public func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
    
}
