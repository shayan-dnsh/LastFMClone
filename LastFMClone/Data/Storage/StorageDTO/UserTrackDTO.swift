//
//  UserTrack.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//

import Foundation
import RealmSwift

/// `UserTrackDTO` Realm object that define user track
class UserTrackDTO: Object {
    @objc dynamic var mbid: String?
    @objc dynamic var name: String?
    var image = RealmSwift.List<ImageDTO>()
    @objc dynamic var artist: ArtistDTO?
    @objc dynamic var url: String?
    @objc dynamic var duration: String?
    @objc dynamic var playcount: String?
    @objc dynamic var listeners: String?
    @objc dynamic var isFavorite = false
    
    override class func primaryKey() -> String? {
        "url"
    }
    
    override init() {
        super.init()
    }
    
    init(model: UserTrack, isFavorited: Bool) {
        self.mbid = model.mbid
        self.name = model.name
        let imageList = model.image?.map { ImageDTO(model: $0) } ?? []
        self.image.append(objectsIn: imageList)
        self.artist = ArtistDTO(model: model.artist)
        self.url = model.url
        self.duration = model.duration
        self.playcount = model.playcount
        self.listeners = model.listeners
        self.isFavorite = isFavorited
    }
    
    func getUserTrack() -> UserTrack {
        var model = UserTrack()
        model.name = name
        model.mbid = mbid
        model.url = url
        model.duration = duration
        model.playcount = playcount
        model.listeners = listeners
        model.artist = artist?.getArtist()
        model.image = image.map { $0.getImage() }
        model.isFavorited = isFavorite
        return model
    }
}
