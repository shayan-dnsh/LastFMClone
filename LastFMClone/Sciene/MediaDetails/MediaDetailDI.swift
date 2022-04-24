//
//  MediaDetailDI.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Foundation


/// `MediaDetailDI` Service Locator media detail page
protocol MediaDetailDI {
    func resolve() -> GetTrackDetailUserCase
    func resolve() -> ChangeFavoriteUserCase
    func resolve() -> MediaDetailViewModel
}

extension MediaDetailDI where Self: BaseDI {
    func resolve() -> GetTrackDetailUserCase {
        GetTrackDetail()
    }
    
    func resolve() -> ChangeFavoriteUserCase {
        ChangeFavorite()
    }
    
    
    func resolve() -> MediaDetailViewModel {
        MediaDetailViewModel(getTrackDetailUseCase: resolve(),
                             changeFavoriteUseCase: resolve())
    }
}
