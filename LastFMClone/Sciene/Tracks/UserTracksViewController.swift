//
//  TracksViewController.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import UIKit
import Combine

class UserTracksViewController: UICollectionViewController {
    
    @IBOutlet weak var emptyState: UIView!
    
    // MARK: - Properties
    var viewModel: UserTracksViewModel?
    var cancelBag = CancelBag()
    
    private var tracks: [TrackItemViewModel] = []
    
    lazy var trackCollectionDelegate: TrackCollectionCellDelegate = {
        TrackCollectionCellDelegate()
    }()
    
    private lazy var dataSource: UserTrackDataSource = {
        let trackDiffable = TrackDiffableDataSource()
        return trackDiffable.makeDataSource(collectionView: collectionView)
    }()
    
    private lazy var loadingTrigger = PassthroughSubject<Void, Never>()
    private lazy var snapShot: TrackDiffableSnapshot = TrackDiffableSnapshot()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1490196078, blue: 0.1725490196, alpha: 1)
        searchBar.searchTextField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        searchBar.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        searchBar.placeholder = "Search Tracks ..."
        searchBar.delegate = self
        return searchBar
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.1490196078, blue: 0.1725490196, alpha: 0.5987643817)
        self.navigationItem.titleView = searchBar
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        loadingTrigger.send()
        
    }
    
    deinit {
        logDeinit()
    }
    
}

// MARK: - Methods
extension UserTracksViewController {
    
    func setupView() {
        bindCollectionItemClicked()
        configureCollectionView()
    }
    
    private func bindCollectionItemClicked() {
        let sub = AnySubscriber<IndexPath, Never>(receiveSubscription: {
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
    
    func configureCollectionView() {
        collectionView.delegate = trackCollectionDelegate
        collectionView.register(TrackCollectionCell.self)
    }
    
}

// MARK: - Delegates
extension UserTracksViewController: UserTrackRouteType {}

extension UserTracksViewController: Bindable {
    
    func bindViewModel() {
        guard let collectionView = self.collectionView as? RefreshableCollectionView else {
            return
        }
        let input = UserTracksViewModel.Input(loadingTrigger: loadingTrigger.eraseToAnyPublisher(),
                                              reloadTrigger: collectionView.refreshTrigger.print().asDriver())
        
        let output = viewModel?.transform(input, cancelBag: cancelBag)
        
        output?.$tracks
            .sink(receiveValue: { [weak self] tracks in
                self?.tracks = tracks
                self?.emptyState.isHidden = !tracks.isEmpty
                if let dataSource = self?.dataSource {
                    self?.snapShot.applySnapshot(dataSource: dataSource,
                                                 userTrackList: self?.tracks ?? [])
                }
                
            })
            .store(in: cancelBag)
        
        output?.$isLoading.subscribe(loadingSubscriber)
        output?.$isReloading.subscribe(collectionView.isRefreshing)
        
    }
}

extension UserTracksViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showSearchPage()
        self.view.endEditing(true)
        self.searchBar.endEditing(true)
    }
}


