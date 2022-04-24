//
//  API+TrackDetail.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/15/21.
//

import Alamofire

// MARK: - Search Track API
extension API {
    func getTrackDetail(_ input: TrackDetailInput) -> Observable<TrackDetailModel> {
        return request(input)
    }
    
    final class TrackDetailInput: APIInput {
        init(dto: TrackDetailParameterDTO) {
            let params: Parameters = [
                "method": "track.getInfo",
                "api_key": dto.apiKey,
                "track": dto.track,
                "artist": dto.artist,
                "format": APIConstants.responseJsonFormat,
                
            ]
            
            super.init(urlString: APIConstants.baseHttpsURL,
                       parameters: params,
                       method: .get,
                       requireAPIKey: true)
            
            usingCache = dto.usingCache
        }
    }
    
}
