//
//  ViewModel+GetPage.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/9/21.
//

import Combine


/**
 Input of page that will use in ViewModel pagination extension
 - Parameter TrigerInput: Specific Output of states
 - Parameter Item: Model that ferched from `ViewModel` getPage
 - Parameter MappedItem: Mapped model from `Item`
 */
public struct GetPageInput<TriggerInput, Item, MappedItem> {
    
    let pageSubject: CurrentValueSubject<PagingInfo<MappedItem>, Never>
    let searchSubject: CurrentValueSubject<String, Never>?
    let errorTracker: ErrorTracker
    let loadTrigger: AnyPublisher<TriggerInput, Never>
    let reloadTrigger: AnyPublisher<TriggerInput, Never>
    let loadMoreTrigger: AnyPublisher<TriggerInput, Never>
    let getItems: (TriggerInput) -> AnyPublisher<PagingInfo<Item>, AppError>
    let reloadItems: (TriggerInput) -> AnyPublisher<PagingInfo<Item>, AppError>
    let loadMoreItems: (TriggerInput, Int) -> AnyPublisher<PagingInfo<Item>, AppError>
    let mapper: (Item) -> MappedItem
    
    
    public init(pageSubject: CurrentValueSubject<PagingInfo<MappedItem>, Never>,
                errorTracker: ErrorTracker,
                loadTrigger: AnyPublisher<TriggerInput, Never>,
                getItems: @escaping (TriggerInput) -> AnyPublisher<PagingInfo<Item>, AppError>,
                reloadTrigger: AnyPublisher<TriggerInput, Never>,
                reloadItems: @escaping (TriggerInput) -> AnyPublisher<PagingInfo<Item>, AppError>,
                loadMoreTrigger: AnyPublisher<TriggerInput, Never>,
                loadMoreItems: @escaping (TriggerInput, Int) -> AnyPublisher<PagingInfo<Item>, AppError>,
                mapper: @escaping (Item) -> MappedItem,
                searchSubject: CurrentValueSubject<String, Never>? = nil) {
        
        self.pageSubject = pageSubject
        self.errorTracker = errorTracker
        self.loadTrigger = loadTrigger
        self.reloadTrigger = reloadTrigger
        self.loadMoreTrigger = loadMoreTrigger
        self.getItems = getItems
        self.reloadItems = reloadItems
        self.loadMoreItems = loadMoreItems
        self.mapper = mapper
        self.searchSubject = searchSubject
        
        
    }
}

public extension GetPageInput {
    /**
     This init method used when we want create an Paging info with page1
     */
    init(pageSubject: CurrentValueSubject<PagingInfo<MappedItem>, Never> = CurrentValueSubject<PagingInfo<MappedItem>, Never>(PagingInfo<MappedItem>()),
         errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: AnyPublisher<TriggerInput, Never>,
         reloadTrigger: AnyPublisher<TriggerInput, Never>,
         loadMoreTrigger: AnyPublisher<TriggerInput, Never>,
         getItems: @escaping (TriggerInput, Int) -> AnyPublisher<PagingInfo<Item>, AppError>,
         mapper: @escaping (Item) -> MappedItem) {
        
        self.init(pageSubject: pageSubject,
                  errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: { triggerInput in getItems(triggerInput, 1) },
                  reloadTrigger: reloadTrigger,
                  reloadItems: { triggerInput in getItems(triggerInput, 1) },
                  loadMoreTrigger: loadMoreTrigger,
                  loadMoreItems: getItems,
                  mapper: mapper)
    }
}

public extension GetPageInput where TriggerInput == Void {
    
    /**
     This init method used when `TriggerInput` is `Void`, So it creates an Paging info with page 1
     */
    init(pageSubject: CurrentValueSubject<PagingInfo<MappedItem>, Never> = CurrentValueSubject<PagingInfo<MappedItem>, Never>(PagingInfo<MappedItem>()),
         errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: AnyPublisher<TriggerInput, Never>,
         reloadTrigger: AnyPublisher<TriggerInput, Never>,
         loadMoreTrigger: AnyPublisher<TriggerInput, Never>,
         getItems: @escaping (Int) -> AnyPublisher<PagingInfo<Item>, AppError>,
         mapper: @escaping (Item) -> MappedItem) {
        
        self.init(pageSubject: pageSubject,
                  errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: { _ in getItems(1) },
                  reloadTrigger: reloadTrigger,
                  reloadItems: { _ in getItems(1) },
                  loadMoreTrigger: loadMoreTrigger,
                  loadMoreItems: { _, page in getItems(page) },
                  mapper: mapper)
    }
}

public extension GetPageInput where Item == MappedItem {
    
    /**
     This init method used when `Item` equal `MappedItem`, So it creates an  Paging info with page 1
     */
    init(pageSubject: CurrentValueSubject<PagingInfo<MappedItem>, Never> = CurrentValueSubject<PagingInfo<MappedItem>, Never>(PagingInfo<MappedItem>()),
         errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: AnyPublisher<TriggerInput, Never>,
         reloadTrigger: AnyPublisher<TriggerInput, Never>,
         loadMoreTrigger: AnyPublisher<TriggerInput, Never>,
         getItems: @escaping (TriggerInput, Int) -> AnyPublisher<PagingInfo<Item>, AppError>) {
        self.init(pageSubject: pageSubject,
                  errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: { triggerInput in getItems(triggerInput, 1) },
                  reloadTrigger: reloadTrigger,
                  reloadItems: { triggerInput in getItems(triggerInput, 1) },
                  loadMoreTrigger: loadMoreTrigger,
                  loadMoreItems: getItems,
                  mapper: { $0 })
    }
}

public extension GetPageInput where Item == MappedItem, TriggerInput == Void {
    
    /**
     This init method used when `Item` equal `MappedItem` and `TriggerInput` equal `Void`, So it creates an  Paging info with page 1
     */
    init(pageSubject: CurrentValueSubject<PagingInfo<MappedItem>, Never> = CurrentValueSubject<PagingInfo<MappedItem>, Never>(PagingInfo<MappedItem>()),
         errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: AnyPublisher<TriggerInput, Never>,
         reloadTrigger: AnyPublisher<TriggerInput, Never>,
         loadMoreTrigger: AnyPublisher<TriggerInput, Never>,
         getItems: @escaping (Int) -> AnyPublisher<PagingInfo<Item>, AppError>) {
        self.init(pageSubject: pageSubject,
                  errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: { _ in getItems(1) },
                  reloadTrigger: reloadTrigger,
                  reloadItems: { _ in getItems(1) },
                  loadMoreTrigger: loadMoreTrigger,
                  loadMoreItems: { _, page in getItems(page) },
                  mapper: { $0 })
    }
}


/**
 A struct that used as Result  of `ViewModel` getItem
 - Parameter Item: Model that ferched from `ViewModel` getPage
 */
public struct GetPageResult<Item> {
    public var page: AnyPublisher<PagingInfo<Item>, Never>
    public var error: AnyPublisher<AppError, Never>
    public var isLoading: AnyPublisher<Bool, Never>
    public var isReloading: AnyPublisher<Bool, Never>
    public var isLoadingMore: AnyPublisher<Bool, Never>
    
    
    /**
     Tupple for of result to make ease of read
     */
    public var destructured: (
        AnyPublisher<PagingInfo<Item>, Never>,
        AnyPublisher<AppError, Never>,
        AnyPublisher<Bool, Never>,
        AnyPublisher<Bool, Never>,
        AnyPublisher<Bool, Never>) {
        return (page, error, isLoading, isReloading, isLoadingMore)
    }
    
    public init(page: AnyPublisher<PagingInfo<Item>, Never>,
                error: AnyPublisher<AppError, Never>,
                isLoading: AnyPublisher<Bool, Never>,
                isReloading: AnyPublisher<Bool, Never>,
                isLoadingMore: AnyPublisher<Bool, Never>) {
        self.page = page
        self.error = error
        self.isLoading = isLoading
        self.isReloading = isReloading
        self.isLoadingMore = isLoadingMore
    }
    
}

public extension ViewModel {
    
    func getPage<TriggetInput, Item, MappedItem> (input: GetPageInput<TriggetInput, Item, MappedItem>) -> GetPageResult<MappedItem>{
        let loadingActivityTracker = ActivityTracker(false)
        let reloadingActivityTracker = ActivityTracker(false)
        let loadingMoreActivityTracker = ActivityTracker(false)
        let loadingMoreSubject = CurrentValueSubject<Bool, Never>(false)
        
        
        let loadItems = Publishers.Merge(
            input.loadTrigger.map { ScreenLoadingType.loading($0) },
            input.reloadTrigger.map { ScreenLoadingType.reloading($0) }
        )
        .filter { _ in
            !loadingActivityTracker.value
                && !reloadingActivityTracker.value
                && !(loadingMoreActivityTracker.value || loadingMoreSubject.value)
        }
        .map { triggerType -> AnyPublisher<PagingInfo<Item>, Never> in
            switch triggerType {
            case .loading(let triggerInput):
                return input.getItems(triggerInput)
                    .trackError(input.errorTracker)
                    .trackActivity(loadingActivityTracker)
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
            case .reloading(let triggerInput):
                return input.reloadItems(triggerInput)
                    .trackError(input.errorTracker)
                    .trackActivity(reloadingActivityTracker)
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
            }
        }
        .switchToLatest()
        .handleEvents(receiveOutput: { page in
            let newPage = PagingInfo<MappedItem>(
                page: page.page,
                items: page.items.map(input.mapper),
                hasMorePages: page.hasMorePages,
                totalItems: page.totalItems,
                itemsPerPage: page.itemsPerPage,
                totalPages: page.totalPages
            )
            
            input.pageSubject.send(newPage)
        })
        
        let loadMoreItems = input.loadMoreTrigger
            .filter { _ in
                !loadingActivityTracker.value
                    && !reloadingActivityTracker.value
                    && !(loadingMoreActivityTracker.value || loadingMoreSubject.value)
            }
            .handleEvents(receiveOutput: { _ in
                if input.pageSubject.value.items.isEmpty {
                    loadingMoreSubject.send(false)
                }
            })
            .filter { _ in !input.pageSubject.value.items.isEmpty }
            .map { triggerInput -> AnyPublisher<PagingInfo<Item>, Never> in
                let page = input.pageSubject.value.page
                
                return input.loadMoreItems(triggerInput, page + 1)
                    .trackError(input.errorTracker)
                    .trackActivity(loadingMoreActivityTracker)
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .filter { !$0.items.isEmpty || !$0.hasMorePages }
            .handleEvents(receiveOutput: { page in
                let currentPage = input.pageSubject.value
                let items = currentPage.items + page.items.map(input.mapper)
                
                let newPage = PagingInfo<MappedItem>(
                    page: page.page,
                    items: items,
                    hasMorePages: page.hasMorePages,
                    totalItems: page.totalItems,
                    itemsPerPage: page.itemsPerPage,
                    totalPages: page.totalPages
                )
                
                input.pageSubject.send(newPage)
            })
        
        
        let page  = Publishers.Merge(loadItems, loadMoreItems)
            .map { _ in input.pageSubject.value }
            .eraseToAnyPublisher()
        
        let error = input.errorTracker.eraseToAnyPublisher()
        let isLoading = loadingActivityTracker.eraseToAnyPublisher()
        let isReloading = reloadingActivityTracker.eraseToAnyPublisher()
        let isLoadingMore = loadingMoreActivityTracker.eraseToAnyPublisher()
        
        return GetPageResult(page: page,
                             error: error,
                             isLoading: isLoading,
                             isReloading: isReloading,
                             isLoadingMore: isLoadingMore)
    }
}


