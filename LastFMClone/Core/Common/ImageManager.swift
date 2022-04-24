//
//  ImageManager.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import AlamofireImage
import Alamofire
import Combine

/// `ImageManager` Dependency Inversion of image managers
protocol ImageManager {
    func retrieveImage(for url: String) -> Observable<Image>
    func cache(_ image: Image, for url: String)
    func cachedImage(for url: String) -> Image? 
}

/// `AlamofireImageManager` User for downloading and cache image used by AlamofireImage
struct AlamofireImageManager: ImageManager {
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    
    func retrieveImage(for url: String) -> Observable<Image> {
        Future<Image, AppError> { promise in
            let request = AF.request(url)
            request.validate()
            request.responseImage { response in
                switch response.result {
                case .success(let image):
                    promise(.success(image))
                    self.cache(image, for: url)
                    
                case .failure(let error):
                    promise(.failure(AppError.serverError(serverFailure:
                                                            ServerFailure(statusCode: response.response?.statusCode,
                                                                description: String(describing: error)))))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func cache(_ image: Image, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    func cachedImage(for url: String) -> Image? {
        return imageCache.image(withIdentifier: url)
    }
    
}

extension UInt64 {
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }

}
