//
//  TrackDI.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//

import UIKit

/// `TrackDI` Service Locator Tracks Page
protocol TrackDI {
    func resolve() -> UserTracksViewModel
    func resolve() -> GetUserTracksUseCase
    func resolve() -> UserTracksViewController
    func resolve() -> MediaDetailViewController
    func resolve() -> SearchViewController
}

extension TrackDI where Self: BaseDI {
    
    func resolve() -> GetUserTracksUseCase {
        GetUserTracks()
    }
    
    func resolve() -> UserTracksViewController {
        let vc = UIStoryboard.load(from: .tracks).instantiateViewController(ofType: UserTracksViewController.self)
        let vm: UserTracksViewModel = resolve()
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve() -> UserTracksViewModel {
        UserTracksViewModel(useCase: resolve())
    }
    
    func resolve() -> MediaDetailViewController {
        let vc = UIStoryboard.load(from: .detail).instantiateViewController(ofType: MediaDetailViewController.self)
        return vc
    }
    
    func resolve() -> SearchViewController {
        let vc = UIStoryboard.load(from: .search).instantiateViewController(ofType: SearchViewController.self)
        return vc
    }
}
