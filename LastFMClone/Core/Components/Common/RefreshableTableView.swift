//
//  RefreshableTableView.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//

import UIKit
import Combine
import CombineCocoa
import ESPullToRefresh

/// `PagingCollectionView` That can use as tableView with `Reloading`  and when it did not need to have load more items. 
open class RefreshableTableView: UITableView {
    
    private let _refreshControl = UIRefreshControl()
    
    private var _refreshTrigger = PassthroughSubject<Void, Never>()
    
    
    open var refreshHeader: (ESRefreshProtocol & ESRefreshAnimatorProtocol)? {
        didSet {
            guard let header = refreshHeader else { return }
            es.addPullToRefresh(animator: header) { [weak self] in
                self?._refreshTrigger.send(())
            }
            removeRefreshControl()
        }
    }
    
    
    open var refreshTrigger: AnyPublisher<Void, Never> {
        return Publishers.Merge(
            _refreshTrigger
                .filter { [weak self] in
                    self?.refreshControl == nil
                },
            _refreshControl.isRefreshingPublisher
                .filter { [weak self] in
                    $0 && self?.refreshControl != nil
                }
                .map { _ in }
        )
        .eraseToAnyPublisher()
    }
    
    open var isRefreshing: GenericSubscriber<Bool> {
        GenericSubscriber(self) { tableView, loading in
            if tableView.refreshHeader == nil {
                if loading {
                    tableView._refreshControl.beginRefreshing()
                } else {
                    if tableView._refreshControl.isRefreshing {
                        tableView._refreshControl.endRefreshing()
                    }
                }
            } else {
                if loading {
                    tableView.es.startPullToRefresh()
                } else {
                    tableView.es.stopPullToRefresh()
                }
            }
        }
    }
    

    override open func awakeFromNib() {
        super.awakeFromNib()
        expiredTimeInterval = 8.0
        addRefreshControl()
    }
    
    func addRefreshControl() {
        refreshHeader = nil
        self.refreshControl = _refreshControl
    }
    
    func removeRefreshControl() {
        self.refreshControl = nil
    }
    
}

