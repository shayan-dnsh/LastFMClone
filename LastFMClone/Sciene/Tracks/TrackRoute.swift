//
//  TrackNavigator.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import UIKit

protocol TrackRouteType where Self: UIViewController {
    func showSearchPage()
    func showTrackDetail(track: TrackItemViewModel)
}

extension TrackRouteType {
    func showSearchPage() {
        let vc = UIStoryboard.load(from: Storyboard.search).instantiateViewController(ofType: SearchViewController.self)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTrackDetail(track: TrackItemViewModel) {
        let vc = UIStoryboard.load(from: Storyboard.search).instantiateViewController(ofType: MediaDetailViewController.self)
        vc.track = track
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

