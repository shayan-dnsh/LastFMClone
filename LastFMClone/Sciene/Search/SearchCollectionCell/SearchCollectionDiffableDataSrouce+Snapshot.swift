//
//  SearchCollectionDiffableDataSrouce+Snapshot.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import UIKit

typealias SearchTrackDataSource = UICollectionViewDiffableDataSource<Section, TrackItemViewModel>
typealias SearchTrackSnapshot = NSDiffableDataSourceSnapshot<Section, TrackItemViewModel>

/// `SearchDiffableDataSource` Data Source of the search track collection cell for diffable collection view

class SearchDiffableDataSource: NSObject {
    
    func makeDataSource(collectionView: UICollectionView) -> SearchTrackDataSource {
        let dataSource = SearchTrackDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reusedId, for: indexPath) as? SearchCollectionViewCell
            cell?.config(item: item)
            return cell
        })
        return dataSource
    }
}

/// `SearchDiffableSnapshot` Snapshot of search track collection cell data for diffable colletionview
class SearchDiffableSnapshot: NSObject {
    func applySnapshot( dataSource: SearchTrackDataSource,
                        userTrackList: [TrackItemViewModel],
                        animatingDifferences: Bool = true) {
        
        var snapshot = SearchTrackSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(userTrackList)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
    }
    
}
