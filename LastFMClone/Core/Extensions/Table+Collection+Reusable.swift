//
//  Table+Collection+Reusable.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Foundation
import UIKit

protocol Reusable: AnyObject {}

// MARK:- TableView
extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        let Nib = UINib.init(nibName: T.reusedId, bundle: nil)
        register(Nib, forCellReuseIdentifier: T.reusedId)
    }
    
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusedId, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reusedId)")
        }
        return cell
    }
}

extension UITableViewCell: Reusable {}

// MARK:- CollectionView
extension UICollectionViewCell: Reusable{}

extension UIViewController: Reusable {}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type){
        let nib = UINib.init(nibName: T.reusedId, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reusedId)
    }
}

extension Reusable {
    static var reusedId: String {
        return String(describing: self)
    }
}


extension UIStoryboard {
    func instantiateViewController<T>(ofType type: T.Type = T.self) -> T where T: UIViewController {
        guard let viewController = instantiateViewController(withIdentifier: type.reusedId) as? T else {
            fatalError()
        }
        return viewController
    }
}
