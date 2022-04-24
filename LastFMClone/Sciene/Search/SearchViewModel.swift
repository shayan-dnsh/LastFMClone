//
//  SearchViewModel.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Combine
import UIKit
import CombineCocoa

/// `SearchViewModel` ViewModel type for search collectionview page

struct SearchViewModel {
    let useCase: SearchTrackUseCase
}

extension SearchViewModel: ViewModel {
        
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let searchSubject: CurrentValueSubject<String, Never>
    }
    
    final class Output: ObservableObject {
        @Published var tracks = [TrackItemViewModel]()
        @Published var isLoading = false
        @Published var isReloading = false
        @Published var isLoadingMore = false
        @Published var errorMessage = "Error occured"
        @Published var isEmpty = false
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        let pageInput = GetPageInput(searchSubject: input.searchSubject,
                                     loadTrigger: input.loadTrigger,
                                     reloadTrigger: input.reloadTrigger,
                                     loadMoreTrigger: input.loadMoreTrigger,
                                     getItems: useCase.searchUserTracks)
        
        
        let (page, error, isLoading, isReloading, isloadingMore) = getPage(input: pageInput).destructured
        
        page
            .map { $0.items.map(TrackItemViewModel.init) }
            .assign(to: \.tracks, on: output)
            .store(in: cancelBag)
        
        
        error
            .receive(on: RunLoop.main)
            .map { $0.localizedDescription }
            .assign(to: \.errorMessage, on: output)
            .store(in: cancelBag)
        
        isLoading
            .assign(to: \.isLoading, on: output)
            .store(in: cancelBag)
        
        isReloading
            .assign(to: \.isReloading, on: output)
            .store(in: cancelBag)
        
        isloadingMore
            .assign(to: \.isLoadingMore, on: output)
            .store(in: cancelBag)
        
        
        
        return output
    }
}

public extension GetPageInput where Item == MappedItem, TriggerInput == Void {
    
    /**
     This init method used when `Item` equal `MappedItem` and `TriggerInput` equal `Void`, So it creates an  Paging info with page 1
     */
    init(pageSubject: CurrentValueSubject<PagingInfo<MappedItem>, Never> = CurrentValueSubject<PagingInfo<MappedItem>, Never>(PagingInfo<MappedItem>()),
         searchSubject: CurrentValueSubject<String, Never>?,
         errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: AnyPublisher<TriggerInput, Never>,
         reloadTrigger: AnyPublisher<TriggerInput, Never>,
         loadMoreTrigger: AnyPublisher<TriggerInput, Never>,
         getItems: @escaping (Int, String) -> AnyPublisher<PagingInfo<Item>, AppError>) {
        self.init(pageSubject: pageSubject,
                  errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: { _ in getItems(1, searchSubject?.value ?? "") },
                  reloadTrigger: reloadTrigger,
                  reloadItems: { _ in getItems(1, searchSubject?.value ?? "") },
                  loadMoreTrigger: loadMoreTrigger,
                  loadMoreItems: { _, page in getItems(page, searchSubject?.value ?? "") },
                  mapper: { $0 })
    }
}
