//
//  MediaDetailViewController.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import UIKit
import Combine
import TagListView
import SafariServices

class MediaDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var wikiLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var listenersLabel: UILabel!
    @IBOutlet weak var lenghtLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var publishedStackView: UIStackView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    // MARK: - Properties
    
    var trackDetail: TrackDetailItemViewModel?
    var track: TrackItemViewModel?
    var viewModel: MediaDetailViewModel?
    var cancelBag = CancelBag()
    
    var di = BaseDI()
    lazy var imageManager: ImageManager = {
        di.resolve()
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func backPrevious(_ sender: UIButton) {
        self.popCurrentViewController()
    }
    
    @IBAction func changeFavorite(_ sender: UIButton) {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
        bookmarkImage.image = bookmarkButton.isSelected ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        guard let trackItem = track else {
            return
        }
        viewModel?.changeFavorite(track: trackItem.userTrack,
                                  favorited: bookmarkButton.isSelected)
    }
    
    
}

// MARK: - Methods

extension MediaDetailViewController: Bindable {
    
    func setupView() {
        tagListView.delegate = self
        checkIsFavorited()
    }
    
    func checkIsFavorited() {
        guard let userTrackItem = track else {
            return
        }
        
        if let isFavorited = viewModel?.isFavorited(track: userTrackItem.userTrack) {
            bookmarkImage.image = isFavorited ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
            bookmarkButton.isSelected = isFavorited
        }
    }
    
    func bindViewModel() {
        
        guard let trackName = self.track?.userTrack.name, let artistName = self.track?.userTrack.artist?.name else {
            return
        }
        
        let input = MediaDetailViewModel.Input(loadingTrigger: Driver.just(()),
                                               trackName: trackName,
                                               albumName: artistName)
        
        let output = viewModel?.transform(input, cancelBag: cancelBag)
        
        output?.$trackDetail
            .sink(receiveValue: { [weak self] trackDetail in
                self?.trackDetail = trackDetail
                self?.loadData(item: trackDetail)
            })
            .store(in: cancelBag)
        
        output?.$isLoading.subscribe(loadingSubscriber)
    }
    
    func loadData(item: TrackDetailItemViewModel) {
        guard let trackDetail = item.trackDetail else {
            return
        }
        trackDetail.toptags?.tag?.forEach({[weak self] tag in
            if let tagName = tag.name {
                self?.tagListView.addTag(tagName)
            }
            
        })
        
        if let wikiContent = trackDetail.wiki?.summary, !wikiContent.isEmpty {
            self.wikiLabel.isHidden = false
            self.wikiLabel.text = wikiContent.withoutHTMLTag
        }
        
        if let publishedDate = trackDetail.wiki?.published, !publishedDate.isEmpty {
            self.publishedStackView.isHidden = false
            self.publishedLabel.text = publishedDate
        }
        
        self.trackNameLabel.text = trackDetail.name
        self.albumNameLabel.text = trackDetail.album?.title
        self.artistNameLabel.text = trackDetail.artist?.name
        self.playCountLabel.text = trackDetail.playcount
        self.listenersLabel.text = trackDetail.listeners
        self.lenghtLabel.text = convertSecondsToMinutesAndSeconds(seconds: trackDetail.duration ?? "")
        
        loadImage(url: trackDetail.album?.image?.last?.text)
        
    }
    
    func showTag(url: String?) {
        guard let url = url else {
            return
        }
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func convertSecondsToMinutesAndSeconds (seconds : String) -> String {
        guard let intSeconds = Int(seconds) else {
            return ""
        }
        return "\((intSeconds / 3600)):\((intSeconds % 3600) / 60):\((intSeconds % 3600) % 60)"
    }
    
    func loadImage(url: String?)  {
        guard let url = url else {
            self.mediaImage.image = UIImage(named: "failed")
            return
        }
        if let cachedImage = imageManager.cachedImage(for: url) {
            self.mediaImage.image = cachedImage
            return
        }
        downloadImage(url: url)
    }
    
    func downloadImage(url: String) {
        imageManager.retrieveImage(for: url).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure:
                self?.mediaImage.image = UIImage(named: "failed")
                break
            }
        } , receiveValue: {[weak self] image in
            self?.mediaImage.image = image
            
        }).store(in: cancelBag)
    }
    
}

// MARK: - Delegates
extension MediaDetailViewController: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        guard let tags = self.trackDetail?.trackDetail?.toptags?.tag else {
            return
        }
        if let tag = tags.first(where: {$0.name == title})  {
            showTag(url: tag.url)
        }
    }
    
    
}
