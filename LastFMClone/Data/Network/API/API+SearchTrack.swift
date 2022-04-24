//
//  API+SearchTrack.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/14/21.
//

import Alamofire

// MARK: - Search Track API
extension API {
    func searchTrackList(_ input: SearchTrackInput) -> Observable<SearchTrackModel> {
        return request(input)
    }
    
    final class SearchTrackInput: APIInput {
        init(dto: SearchParameterDTO) {
            let params: Parameters = [
                "method": "track.search",
                "api_key": dto.apiKey,
                "track": dto.term,
                "page": dto.page,
                "limit": dto.perPage,
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
