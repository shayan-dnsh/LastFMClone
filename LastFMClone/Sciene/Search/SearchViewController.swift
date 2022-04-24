//
//  SearchViewController.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import UIKit
import Combine
import CombineCocoa

class SearchViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    var viewModel: SearchViewModel?
    var cancelBag = CancelBag()
    
    private var tracks: [TrackItemViewModel] = []
    
    lazy var trackCollectionDelegate: SearchCollectionCellDelegate = {
        var delegate = SearchCollectionCellDelegate()
        return delegate
    }()
    
    private lazy var dataSource: SearchTrackDataSource = {
        let trackDiffable = SearchDiffableDataSource()
        return trackDiffable.makeDataSource(collectionView: collectionView)
    }()
    
    private lazy var snapShot: SearchDiffableSnapshot = SearchDiffableSnapshot()

    private lazy var loadTrigger = PassthroughSubject<Void, Never>()
    private lazy var searchTrigger = CurrentValueSubject<String, Never>("")
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1490196078, blue: 0.1725490196, alpha: 1)
        searchBar.searchTextField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        searchBar.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        searchBar.delegate = self
        searchBar.placeholder = "Search Tracks ..."
        return searchBar
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.1490196078, blue: 0.1725490196, alpha: 0.5987643817)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

}

// MARK: - Methods

extension SearchViewController {
    
    private func configureCollectionView() {
        collectionView.delegate = trackCollectionDelegate
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(SearchCollectionViewCell.self)
    }
    
    func setupView() {
        bindCollectionItemClicked()
        configureCollectionView()
    }
    
    private func bindCollectionItemClicked() {
        let sub = AnySubscriber<IndexPath, Never>(receiveSubscription: {
            print("receiveSubscription \($0)")
            $0.request(.unlimited)
        }, receiveValue: { [weak self] in
            let row = $0.row
            if let track = self?.tracks[row] {
                self?.showTrackDetail(track: track)
            }
            return .unlimited
        }, receiveCompletion: nil)
        
        trackCollectionDelegate.itemReceiver.subscribe(sub)
    }
    
}

// MARK: - Delegates

extension SearchViewController: UserTrackRouteType {}

extension SearchViewController: Bindable {
    
    func bindViewModel() {
        guard let collectionView = self.collectionView as? PagingCollectionView else {
            return
        }
        
        let input = SearchViewModel.Input(loadTrigger: loadTrigger.eraseToAnyPublisher(),
                                          reloadTrigger: collectionView.refreshTrigger.print().asDriver(),
                                          loadMoreTrigger: collectionView.loadMoreTrigger,
                                          searchSubject: searchTrigger)

        let output = viewModel?.transform(input, cancelBag: cancelBag)

        output?.$tracks
            .sink(receiveValue: { [weak self] tracks in
                self?.tracks = tracks
                if let dataSource = self?.dataSource {
                    self?.snapShot.applySnapshot(dataSource: dataSource,
                                                 userTrackList: self?.tracks ?? [])
                }
                
            })
            .store(in: cancelBag)

        output?.$isLoading.subscribe(loadingSubscriber)
        output?.$isReloading.subscribe(collectionView.isRefreshing)
        output?.$isLoadingMore.subscribe(collectionView.isLoadingMore)
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        searchTrigger.send(text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        searchBar.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [weak self] in
            self?.loadTrigger.send()
        }
        
    }
}
