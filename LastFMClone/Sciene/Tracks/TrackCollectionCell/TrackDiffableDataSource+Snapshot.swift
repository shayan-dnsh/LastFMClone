//
//  TrackDiffableDataSource.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/12/21.
//

import UIKit


/// `TrackDiffableDataSource` Data Source of the track collection cell for diffable collection view
enum Section {
    case main
}

typealias UserTrackDataSource = UICollectionViewDiffableDataSource<Section, TrackItemViewModel>
typealias UserTrackSnapshot = NSDiffableDataSourceSnapshot<Section, TrackItemViewModel>


class TrackDiffableDataSource: NSObject {
    
    func makeDataSource(collectionView: UICollectionView) -> UserTrackDataSource {
        let dataSource = UserTrackDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionCell.reusedId, for: indexPath) as? TrackCollectionCell
            cell?.config(item: item)
            return cell
        })
        return dataSource
    }
}

/// `TrackDiffableSnapshot` Snapshot of track collection cell data for diffable colletionview
class TrackDiffableSnapshot: NSObject {
    func applySnapshot( dataSource: UserTrackDataSource,
                        userTrackList: [TrackItemViewModel],
                        animatingDifferences: Bool = true) {
        
        var snapshot = UserTrackSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(userTrackList)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
    }
    
}




