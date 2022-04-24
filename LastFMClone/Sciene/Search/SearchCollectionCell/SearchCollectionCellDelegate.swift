//
//  SearchCollectionCellDelegate.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import UIKit
import Combine

/// `SearchCollectionCellDelegate` Search collection list flow layout delegate in seperate
class SearchCollectionCellDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    let itemClickTrigger = PassthroughSubject<IndexPath, Never>()
    lazy var itemReceiver = itemClickTrigger.receive(on: RunLoop.main)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (180 * ScreenSize.SCREEN_WIDTH) / 375
        let height = width
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        itemClickTrigger.send(indexPath)
    }
    

}
