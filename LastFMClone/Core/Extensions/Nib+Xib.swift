//
//  Nib+Xib.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Foundation
import UIKit

// MARK:- StoryBoard
extension UIStoryboard {
    static func load(from storyboard: Storyboard) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil)
    }
}


// MARK:- UINib
private extension UINib {
    
    static func nib(named nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static func loadNibView(_ nibName: String, owner: Any?) -> UIView {
        return nib(named: nibName).instantiate(withOwner: owner, options: nil)[0] as! UIView
    }
    
}
