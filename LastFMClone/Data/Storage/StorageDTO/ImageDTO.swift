//
//  ImageDTO.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//

import RealmSwift

/// `ImageDTO` Realm object that define user image
class ImageDTO: Object {
    @objc dynamic var size: String?
    @objc dynamic var text: String?

    override init() {
        super.init()
    }
    
    init(model: TrackImage) {
        self.size = model.size?.rawValue
        self.text = model.text
    }
    
    func getImage() -> TrackImage {
        TrackImage(size: Size(rawValue: size ?? Size.large.rawValue),
              text: text)
    }
}
