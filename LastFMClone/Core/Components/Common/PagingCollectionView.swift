//
//  PagingCollectionView.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//

import UIKit
import Combine
import CombineCocoa
import ESPullToRefresh


/// `PagingCollectionView` That can use as collectionView with `Reloading` and `LoadMore` behaviour. Called lazy laod

open class PagingCollectionView: UICollectionView {
    
    private let _refreshControl = UIRefreshControl()
    
    private var _refreshTrigger = PassthroughSubject<Void, Never>()
    
    private var _loadMoreTrigger = PassthroughSubject<Void, Never>()
    
    
    open var loadMoreTrigger: AnyPublisher<Void, Never> {
        _loadMoreTrigger.eraseToAnyPublisher()
    }
    
    
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
        GenericSubscriber(self) { collectionView, loading in
            if collectionView.refreshHeader == nil {
                if loading {
                    collectionView._refreshControl.beginRefreshing()
                } else {
                    if collectionView._refreshControl.isRefreshing {
                        collectionView._refreshControl.endRefreshing()
                    }
                }
            } else {
                if loading {
                    collectionView.es.startPullToRefresh()
                } else {
                    collectionView.es.stopPullToRefresh()
                }
            }
        }
    }
    
    
    open var refreshFooter: (ESRefreshProtocol & ESRefreshAnimatorProtocol)? {
        didSet {
            guard let footer = refreshFooter else { return }
            es.addInfiniteScrolling(animator: footer) { [weak self] in
                self?._loadMoreTrigger.send()
            }
        }
    }
    
    open var isLoadingMore: GenericSubscriber<Bool> {
        return GenericSubscriber(self) { collectionView, loading in
            if loading {
                collectionView.es.base.footer?.startRefreshing()
            } else {
                collectionView.es.stopLoadingMore()
            }
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        expiredTimeInterval = 8.0
        addRefreshControl()
        refreshFooter = RefreshFooterAnimator(frame: .zero)
    }
    
    func addRefreshControl() {
        refreshHeader = nil
        self.refreshControl = _refreshControl
    }
    
    func removeRefreshControl() {
        self.refreshControl = nil
    }
    
}
