//
//  SearchDI.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import UIKit

/// `SearchDI` Service Locator Search page
protocol SearchDI {
    func resolve() -> SearchTrackUseCase
    func resolve() -> SearchViewModel
}


extension SearchDI where Self: BaseDI {
    
    func resolve() -> SearchTrackUseCase {
        SearchTrack()
    }
    
    func resolve() -> SearchViewModel {
        SearchViewModel(useCase: resolve())
    }
    
}
