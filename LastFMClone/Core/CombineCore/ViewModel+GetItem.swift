//
//  ViewModel+GetItem.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/8/21.
//

import Combine


/**
 A struct that used as `ViewModel`  getItem Input
 - Parameter TrigerInput: Specific Output of states
 - Parameter Item: Model that ferched from `ViewModel` getPage
 */
public struct GetItemInput<TriggerInput, Item> {
    
    let errorTracker: ErrorTracker
    let loadTrigger: AnyPublisher<TriggerInput, Never>
    let getItem: (TriggerInput) -> AnyPublisher<Item, AppError>
    let reloadItem: (TriggerInput) -> AnyPublisher<Item, AppError>
    
    public init(errorTracker: ErrorTracker,
                loadTrigger: AnyPublisher<TriggerInput, Never>,
                getItem: @escaping (TriggerInput) -> AnyPublisher<Item, AppError>,
                reloadItem: @escaping (TriggerInput) -> AnyPublisher<Item, AppError>) {
        self.errorTracker = errorTracker
        self.loadTrigger = loadTrigger
        self.getItem = getItem
        self.reloadItem = reloadItem
    }
}

/// Another way for init getItemInput
public extension GetItemInput {
    init(errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: AnyPublisher<TriggerInput, Never>,
         getItem: @escaping (TriggerInput) -> AnyPublisher<Item, AppError>) {
        self.init(errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItem: getItem,
                  reloadItem: getItem)
    }
}

/**
 A struct that used as Result  of `ViewModel` getItem
 - Parameter Item: Model that ferched from `ViewModel` getPage
 */
public struct GetItemResult<Item> {
    public var item: AnyPublisher<Item, Never>
    public var error: AnyPublisher<AppError, Never>
    public var isLoading: AnyPublisher<Bool, Never>
    
    /**
     Tupple for of result to make ease of read
     */
    public var destructured: (
        AnyPublisher<Item, Never>,
        AnyPublisher<AppError, Never>,
        AnyPublisher<Bool, Never>) {
        return (item, error, isLoading)
    }
    
    public init(item: AnyPublisher<Item, Never>,
                error: AnyPublisher<AppError, Never>,
                isLoading: AnyPublisher<Bool, Never>) {
        self.item = item
        self.error = error
        self.isLoading = isLoading
    }
}


extension ViewModel {
    /**
     A struct that used as Result  of `ViewModel` getItem
     - Parameter input: A `GetItemInput` type to getItem result and track states
     */
    public func getItem<TriggerInput, Item>(input: GetItemInput<TriggerInput, Item>) -> GetItemResult<Item> {
        let loadingActivityTracker = ActivityTracker(false)
        
        let item = Publishers.MergeMany(
                input.loadTrigger.map { ScreenLoadingType.loading($0) }
            )
            .filter { _ in
                !loadingActivityTracker.value
            }
            .map { triggerType -> AnyPublisher<Item, Never> in
                switch triggerType {
                case .loading(let triggerInput):
                    return input.getItem(triggerInput)
                        .trackError(input.errorTracker)
                        .trackActivity(loadingActivityTracker)
                        .catch { _ in Empty() }
                        .eraseToAnyPublisher()
                case .reloading(let triggerInput):
                    return input.reloadItem(triggerInput)
                        .trackError(input.errorTracker)
                        .trackActivity(loadingActivityTracker)
                        .catch { _ in Empty() }
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .eraseToAnyPublisher()
            
        let error = input.errorTracker.eraseToAnyPublisher()
        let isLoading = loadingActivityTracker.eraseToAnyPublisher()
        
        return GetItemResult(
            item: item,
            error: error,
            isLoading: isLoading
        )
    }
}
