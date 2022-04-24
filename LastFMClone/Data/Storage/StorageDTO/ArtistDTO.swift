//
//  ArtistDTO.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/13/21.
//

import RealmSwift

/// `ArtistDTO` Realm object that define user artist
class ArtistDTO: Object {
    @objc dynamic var url: String?
    @objc dynamic var name: String?
    @objc dynamic var mbid: String?
    
    override init() {
        super.init()
    }
    
    init(model: Artist?) {
        self.url = model?.url
        self.name = model?.name
        self.mbid = model?.mbid
    }
    
    func getArtist() -> Artist {
         Artist(url: url,
                name: name,
                mbid: mbid)
    }
}
