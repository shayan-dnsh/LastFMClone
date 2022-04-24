//
//  ViewModel+GetList.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/8/21.
//

import Combine

/**
 A struct that used as `ViewModel`  getList Input
 - Parameter TrigerInput: Specific Output of states
 - Parameter Item: Model that ferched from `ViewModel` getPage
 - Parameter MappedItem: Mapped model from `Item`
 */
public struct GetListInput<TriggerInput, Item, MappedItem> {
    let errorTracker: ErrorTracker
    let loadTrigger: AnyPublisher<TriggerInput, Never>
    let reloadTrigger: AnyPublisher<TriggerInput, Never>
    let getItems: (TriggerInput) -> AnyPublisher<[Item], AppError>
    let reloadItems: (TriggerInput) -> AnyPublisher<[Item], AppError>
    let mapper: (Item) -> MappedItem
    
    public init(errorTracker: ErrorTracker,
                loadTrigger: AnyPublisher<TriggerInput, Never>,
                getItems: @escaping (TriggerInput) -> AnyPublisher<[Item], AppError>,
                reloadTrigger: AnyPublisher<TriggerInput, Never>,
                reloadItems: @escaping (TriggerInput) -> AnyPublisher<[Item], AppError>,
                mapper: @escaping (Item) -> MappedItem) {
        self.errorTracker = errorTracker
        self.loadTrigger = loadTrigger
        self.reloadTrigger = reloadTrigger
        self.getItems = getItems
        self.reloadItems = reloadItems
        self.mapper = mapper
    }
    
}

public extension GetListInput {
    init(errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: AnyPublisher<TriggerInput, Never>,
         reloadTrigger: AnyPublisher<TriggerInput, Never>,
         getItems: @escaping (TriggerInput) -> AnyPublisher<[Item], AppError>,
         mapper: @escaping (Item) -> MappedItem) {
        
        self.init(errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: getItems,
                  reloadTrigger: reloadTrigger,
                  reloadItems: getItems,
                  mapper: mapper)
    }
}

public extension GetListInput where Item == MappedItem {
    init(errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: AnyPublisher<TriggerInput, Never>,
         reloadTrigger: AnyPublisher<TriggerInput, Never>,
         getItems: @escaping (TriggerInput) -> AnyPublisher<[Item], AppError>) {
        
        self.init(errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: getItems,
                  reloadTrigger: reloadTrigger,
                  reloadItems: getItems,
                  mapper: { $0 })
    }
}

/**
 A struct that used as Result  of `ViewModel` getList
 - Parameter Item: Model that ferched from `ViewModel` getPage
 */
public struct GetListResult<Item> {
    public var items: AnyPublisher<[Item], Never>
    public var error: AnyPublisher<AppError, Never>
    public var isLoading: AnyPublisher<Bool, Never>
    public var isReloading: AnyPublisher<Bool, Never>
    
    /**
     Tupple for of result to make ease of read
     */
    public var destructured: (
        AnyPublisher<[Item], Never>,
        AnyPublisher<AppError, Never>,
        AnyPublisher<Bool, Never>,
        AnyPublisher<Bool, Never>) {
        return (items, error, isLoading, isReloading)
    }
    
    
    public init(items: AnyPublisher<[Item], Never>,
                error: AnyPublisher<AppError, Never>,
                isLoading: AnyPublisher<Bool, Never>,
                isReloading: AnyPublisher<Bool, Never>) {
        self.items = items
        self.error = error
        self.isLoading = isLoading
        self.isReloading = isReloading
    }
}

extension ViewModel {
    
    /**
     A struct that used as Result  of `ViewModel` getIList
     - Parameter input: A `GetItemInput` type to getList resulst and tracking  states
     */
    public func getList<TriggetInput, Item, MappedItem>(input: GetListInput<TriggetInput, Item, MappedItem>)
    -> GetListResult<MappedItem>{
        let loadingActivtyTracker = ActivityTracker(false)
        let reloadActivtyTracker = ActivityTracker(false)
        
        let items = Publishers.Merge(input.loadTrigger.map { ScreenLoadingType.loading($0) },
                                     input.reloadTrigger.map { ScreenLoadingType.reloading($0) })
            .filter { _ in
                !loadingActivtyTracker.value && !reloadActivtyTracker.value
            }
            .map { triggerType -> AnyPublisher<[Item], Never> in
                switch triggerType {
                case .loading(let triggerInput):
                    return input.getItems(triggerInput)
                        .trackError(input.errorTracker)
                        .trackActivity(loadingActivtyTracker)
                        .catch {_ in Empty()}
                        .eraseToAnyPublisher()
                    
                case .reloading(let triggerInput):
                    return input.reloadItems(triggerInput)
                        .trackError(input.errorTracker)
                        .trackActivity(reloadActivtyTracker)
                        .catch {_ in Empty()}
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .map { $0.map(input.mapper)}
            .eraseToAnyPublisher()
        
        let error = input.errorTracker.eraseToAnyPublisher()
        let isLoading = loadingActivtyTracker.eraseToAnyPublisher()
        let isReloading = reloadActivtyTracker.eraseToAnyPublisher()
        
        return GetListResult(items: items,
                             error: error,
                             isLoading: isLoading,
                             isReloading: isReloading)
        
    }
}
