//
//  APIService.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Alamofire


/// `API` Is a APIBase class with customized handle error  to use in whole remote network layer
final class API: APIBase {
    static var shared: API = API()
    
    
    override func handleResponseError(dataResponse: DataResponse<Data, AFError>, json: JSONDictionary?) -> AppError {
        if let json = json, let message = json["message"] as? String {
            return AppError.serverError(serverFailure: ServerFailure(statusCode: dataResponse.response?.statusCode, description: message) )
        }
        return super.handleResponseError(dataResponse: dataResponse, json: json)
    }
    
}

