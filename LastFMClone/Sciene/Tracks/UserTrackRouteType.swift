//
//  TrackNavigator.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import UIKit


/// `UserTrackRouteType` Routing for tracks page 

protocol UserTrackRouteType where Self: UIViewController {
    var di: DependencyInjection {get}
    
    func showSearchPage()
    func showTrackDetail(track: TrackItemViewModel)
}

extension UserTrackRouteType {
    
    var di: DependencyInjection {
        BaseDI()
    }
    
    func showSearchPage() {
        let vc: SearchViewController = di.resolve()
        let vm: SearchViewModel = di.resolve()
        vc.bindViewModel(to: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTrackDetail(track: TrackItemViewModel) {
        let vc: MediaDetailViewController = di.resolve()
        vc.track = track
        let vm: MediaDetailViewModel = di.resolve()
        vc.bindViewModel(to: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
