//
//  CommonDI.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import Foundation

/// `CommonDI` Service Locator for general objects
protocol CommonDI {
    func resolve() -> ImageManager
}


extension CommonDI where Self: DependencyInjection {
    
func resolve() -> ImageManager {
        AlamofireImageManager()
    }
    
}
