//
//  ViewController+.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import UIKit

// MARK:- UIViewController
extension UIViewController {
    
    @objc func popCurrentViewController() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    public func logDeinit() {
        print(String(describing: type(of: self)) + " deinit")
    }

}
