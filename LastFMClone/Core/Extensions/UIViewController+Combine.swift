//
//  UIViewController+Combine.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//


import UIKit
import Combine
import MBProgressHUD

// MARK:- UIViewController + Combine
extension UIViewController {
    var loadingSubscriber: GenericSubscriber<Bool> {
        GenericSubscriber(self) { (vc, isLoading) in
            if isLoading {
                let hud = MBProgressHUD.showAdded(to: vc.view, animated: true)
                hud.offset.y = -30
            } else {
                MBProgressHUD.hide(for: vc.view, animated: true)
            }
        }
    }
}
