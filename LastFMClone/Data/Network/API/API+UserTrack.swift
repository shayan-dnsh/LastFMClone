//
//  API+UserTrack.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Alamofire

// MARK: - Get User UserTrack API
extension API {
    func getUserTrackList(_ input: GetUserTrackListInput) -> Observable<UserTrackModel> {
        return request(input)
    }
    
    final class GetUserTrackListInput: APIInput {
        init(dto: InputParameterDTO) {
            let params: Parameters = [
                "method": "user.gettoptracks",
                "api_key": dto.apiKey,
                "format": APIConstants.responseJsonFormat,
                "user": dto.userName,
            ]
            super.init(urlString: APIConstants.baseHttpsURL,
                       parameters: params,
                       method: .get,
                       requireAPIKey: true)
            
            usingCache = dto.usingCache
        }
    }
    
}
