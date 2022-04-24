//
//  SearchTrackRouteType.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import UIKit


/// `SearchTrackRouteType` Routing for search page if needed

protocol SearchTrackRouteType where Self: UIViewController {
    var di: DependencyInjection { get }
}

extension SearchTrackRouteType {
    
    var di: DependencyInjection {
        BaseDI()
    }
}
