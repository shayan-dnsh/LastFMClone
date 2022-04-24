//
//  MediaDetailViewModel.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Combine
import UIKit
import CombineCocoa

/// `MediaDetailViewModel` ViewModel type that used in media detail page

struct MediaDetailViewModel {
    let getTrackDetailUseCase: GetTrackDetailUserCase
    let changeFavoriteUseCase: ChangeFavoriteUserCase
    
    func changeFavorite(track: UserTrack, favorited: Bool) {
        changeFavoriteUseCase.changeFavorite(track: track, favorited: favorited)
    }
    
    func isFavorited(track: UserTrack) -> Bool {
        return track.isFavorited ?? false
    }
}


extension MediaDetailViewModel: ViewModel {
    
    struct Input {
        let loadingTrigger: Driver<Void>
        let trackName: String
        let albumName: String
    }
    
    final class Output: ObservableObject {
        @Published var trackDetail = TrackDetailItemViewModel()
        @Published var isLoading = false
        @Published var isReloading = false
        @Published var errorMessage = "Error occured"
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        let inputItem = GetItemInput(loadTrigger: input.loadingTrigger,
                                     trackName: input.trackName,
                                     albumName: input.albumName,
                                     getItem: getTrackDetailUseCase.getTrackDetail)
        
        let (item, error, isLoading) = getItem(input: inputItem).destructured
        
        item
            .map { TrackDetailItemViewModel.init(trackDetail: $0) }
            .assign(to: \.trackDetail, on: output)
            .store(in: cancelBag)

        
        error
            .receive(on: RunLoop.main)
            .map { $0.localizedDescription }
            .assign(to: \.errorMessage, on: output)
            .store(in: cancelBag)

        isLoading
            .assign(to: \.isLoading, on: output)
            .store(in: cancelBag)

        return output
    }
    
}

/// Used for trackInfo
public extension GetItemInput {
    init(errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: AnyPublisher<TriggerInput, Never>,
         trackName: String,
         albumName: String,
         getItem: @escaping (String, String) -> AnyPublisher<Item, AppError>) {
        self.init(errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItem: {_ in getItem(trackName, albumName) },
                  reloadItem: {_ in getItem(trackName, albumName) })
    }
}
