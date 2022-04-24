//
//  TrackCollectionCellFlowLayout.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import UIKit
import Combine

/// `TrackCollectionCellDelegate` Track collection list flow layout delegate in seperate 
class TrackCollectionCellDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    let itemClickTrigger = PassthroughSubject<IndexPath, Never>()
    lazy var itemReceiver = itemClickTrigger.receive(on: RunLoop.main)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (150 * ScreenSize.SCREEN_WIDTH) / 375
        let height = width + 50
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        itemClickTrigger.send(indexPath)
    }
    

    
}
