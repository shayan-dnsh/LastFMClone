//
//  SearchCollectionViewCell.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import UIKit


/// `SearchCollectionViewCell` Custom tablecell for search collectionview
class SearchCollectionViewCell: UICollectionViewCell {
    
    var item: TrackItemViewModel?
    var di = BaseDI()
    var cancelBag = CancelBag()
    
    lazy var imageManager: ImageManager = {
        di.resolve()
    }()
    
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var trackLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var listenersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mediaImage.layer.masksToBounds = true
        mediaImage.clipsToBounds = true
    }
    
    func config(item: TrackItemViewModel) {
        self.item = item
        let track = item.userTrack
        
        if let image = track.image?.last {
            loadImage(url: image.text)
        }
        trackLabel.text = track.name
        artistLabel.text = track.artist?.name
        
        if let listeners = track.listeners, !listeners.isEmpty {
            listenersLabel.text = listeners
        } else {
            listenersLabel.isHidden = true
        }
        
    }
    
    func loadImage(url: String?)  {
        
        guard let url = url else {
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.stopAnimating()
            }

            return
        }
        if let cachedImage = imageManager.cachedImage(for: url) {
            self.mediaImage.image = cachedImage
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.stopAnimating()
            }
            
            return
        }
        downloadImage(url: url)
    }
    
    func downloadImage(url: String) {
        DispatchQueue.main.async { [weak self ] in
            self?.loadingIndicator.startAnimating()
        }
        
        imageManager.retrieveImage(for: url).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                }
                
                break
            case .failure:
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                }
                self?.mediaImage.image = UIImage(named: "failed")
                break
            }
        } , receiveValue: {[weak self] image in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
            }
            self?.mediaImage.image = image
            
        }).store(in: cancelBag)
    }


}
