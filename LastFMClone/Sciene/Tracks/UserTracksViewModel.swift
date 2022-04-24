//
//  TracksViewModel.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Combine
import UIKit


/// `UserTracksViewModel` ViewModel of user track 

struct UserTracksViewModel {
    let useCase: GetUserTracksUseCase
}

extension UserTracksViewModel: ViewModel {
    
    struct Input {
        let loadingTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
    }
    
    final class Output: ObservableObject {
        @Published var tracks = [TrackItemViewModel]()
        @Published var isLoading = false
        @Published var isReloading = false
        @Published var errorMessage = "Error occured"
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        let getListInput = GetListInput(loadTrigger: input.loadingTrigger,
                                        reloadTrigger: input.reloadTrigger,
                                        getItems: useCase.getUserTracks)
        
        let (page, error, isLoading, isReloading) = getList(input: getListInput).destructured
        
        
        page
            .map { $0.map(TrackItemViewModel.init) }
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
        
        
        

        return output
    }
    
}



