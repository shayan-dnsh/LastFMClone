//
//  TrackCollectionCell.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import UIKit

/// `TrackCollectionCell` Custom main page track cell
class TrackCollectionCell: UICollectionViewCell {

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
    }
    
    func loadImage(url: String?)  {
        
        guard let url = url else {
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
                DispatchQueue.main.async { [weak self] in
                    self?.loadingIndicator.stopAnimating()
                }
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    self?.loadingIndicator.stopAnimating()
                }
                self?.mediaImage.image = UIImage(named: "failed")
            }
        } , receiveValue: {[weak self] image in
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.stopAnimating()
                
            }
            self?.mediaImage.image = image
            
        }).store(in: cancelBag)
    }
    

}
