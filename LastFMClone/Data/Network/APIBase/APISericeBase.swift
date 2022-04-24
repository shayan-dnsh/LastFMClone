//
//  APIBaseService.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Foundation
import Alamofire
import UIKit
import Combine

/// Core of networking and get data with `Alamofire` and set states use `Combine`

public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [JSONDictionary]
public typealias ResponseHeader = [AnyHashable: Any]

public protocol JSONData {
    init()
}

extension JSONDictionary: JSONData {}

extension JSONArray: JSONData {}

open class APIBase {
    public var manager: Alamofire.Session
    public var logOptions = LogOptions.default
    
    public init(configuration: URLSessionConfiguration) {
        manager = Alamofire.Session(configuration: configuration)
    }
    
    public convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        
        self.init(configuration: configuration)
    }
    
    open func request<T: Decodable>(_ input: APIInputBase) -> AnyPublisher<APIResponse<T>, AppError> {
        let response: AnyPublisher<APIResponse<JSONDictionary>, AppError> = requestJSON(input)
        
        return response
            .tryMap { apiResponse -> APIResponse<T> in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: apiResponse.data,
                                                              options: .prettyPrinted)
                    let t = try JSONDecoder().decode(T.self, from: jsonData)
                    return APIResponse(header: apiResponse.header, data: t)
                } catch {
                    print(String(describing: error))
                    throw AppError.serverError(serverFailure: ServerFailure(statusCode: nil, description: "Invalid Response Error"))
                }
            }
            .mapError { AppError.map($0) }
            .eraseToAnyPublisher()
    }
    
    open func request<T: Decodable>(_ input: APIInputBase) -> AnyPublisher<T, AppError> {
        request(input)
            .map { $0.data }
            .eraseToAnyPublisher()
    }

    
    open func request<T: Codable>(_ input: APIInputBase) -> AnyPublisher<APIResponse<[T]>, AppError> {
        let response: AnyPublisher<APIResponse<JSONArray>, AppError> = requestJSON(input)

        return response
            .tryMap { apiResponse -> APIResponse<[T]> in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: apiResponse.data,
                                                              options: .prettyPrinted)

                    let items = try JSONDecoder().decode([T].self, from: jsonData)
                    return APIResponse(header: apiResponse.header,
                                       data: items)
                } catch {
                    throw AppError.serverError(serverFailure: ServerFailure(statusCode: nil, description: "Invalid Response Error"))
                }
            }
            .mapError { AppError.map($0) }
            .eraseToAnyPublisher()
    }
    
    open func request<T: Decodable>(_ input: APIInputBase) -> AnyPublisher<[T], AppError> {
        request(input)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    open func requestJSON<U: JSONData>(_ input: APIInputBase) -> AnyPublisher<APIResponse<U>, AppError> {
        
        let urlRequest = preprocess(input)
            .handleEvents(receiveOutput: { [unowned self] input in
                if self.logOptions.contains(.request) {
                    print(input.description(isIncludedParameters: self.logOptions.contains(.requestParameters)))
                }
            })
            .map { [unowned self] input -> DataRequest in
                let request: DataRequest
                
                request = self.manager.request(
                    input.urlString,
                    method: input.method,
                    parameters: input.parameters,
                    encoding: input.encoding,
                    headers: input.headers
                )
                
                return request
            }
            .handleEvents(receiveOutput: { (dataRequest) in
                if self.logOptions.contains(.rawRequest) {
                    debugPrint(dataRequest)
                }
            })
            
            .flatMap { dataRequest -> AnyPublisher<DataResponse<Data, AFError>, AppError> in
                return dataRequest.publishData()
                    .setFailureType(to: AppError.self)
                    .mapError { AppError.map($0) }
                    .eraseToAnyPublisher()
            }
            .tryMap { (dataResponse) -> APIResponse<U> in
                return try self.process(dataResponse)
            }
            
            .tryCatch { [unowned self] error -> AnyPublisher<APIResponse<U>, AppError> in
                return try self.handleRequestError(AppError.map(error), input: input)
            }
            .handleEvents(receiveOutput: { response in
                if input.usingCache {
                    DispatchQueue.global().async {
                        try? CacheRequestManager.sharedInstance.write(urlString: input.urlEncodingString,
                                                               data: response.data,
                                                               header: response.header)
                    }
                }
            })
            .mapError { AppError.map($0) }
            .eraseToAnyPublisher()
        
        let cacheRequest: AnyPublisher<APIResponse<U>, AppError> = Just(input)
            .setFailureType(to: Error.self)
            .filter { $0.usingCache }
            .tryMap { input -> (Any, ResponseHeader?) in
                return try CacheRequestManager.sharedInstance.read(urlString: input.urlEncodingString)
            }
            .catch { _ in Empty() }
            .filter { $0.0 is U }
            .map { data, header -> APIResponse<U> in
                APIResponse(header: header, data: data as! U) // swiftlint:disable:this force_cast
            }
            .handleEvents(receiveOutput: { [unowned self] response in
                if self.logOptions.contains(.cache) {
                    print("[CACHE]")
                    print(response.data)
                }
            })
            .mapError { AppError.map($0) }
            .eraseToAnyPublisher()
        
        return input.usingCache
            ? Publishers.Concatenate(prefix: cacheRequest, suffix: urlRequest)
                .eraseToAnyPublisher()
            : urlRequest
    }
    
    open func preprocess(_ input: APIInputBase) -> AnyPublisher<APIInputBase, AppError> {
        Just(input)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    open func process<U: JSONData>(_ dataResponse: DataResponse<Data, AFError>) throws -> APIResponse<U> {
        let error: AppError
        
        switch dataResponse.result {
        case .success(let data):
            let json: U? = (try? JSONSerialization.jsonObject(with: data, options: [])) as? U
            
            guard let statusCode = dataResponse.response?.statusCode else {
                throw AppError.serverError(serverFailure: ServerFailure.init(statusCode: nil, description: "Unknown Error"))
            }
            
            switch statusCode {
            case 200..<300:
                if logOptions.contains(.responseStatus) {
                    print("👍 [\(statusCode)] " + (dataResponse.response?.url?.absoluteString ?? ""))
                }
                
                if logOptions.contains(.dataResponse) {
                    print(dataResponse)
                }
                
                if logOptions.contains(.responseData) {
                    print("[RESPONSE DATA]")
                    print(json ?? data)
                }
                
                return APIResponse(header: dataResponse.response?.allHeaderFields, data: json ?? U.init())
            default:
                error = handleResponseError(dataResponse: dataResponse, json: json)
                
                if logOptions.contains(.responseStatus) {
                    print("❌ [\(statusCode)] " + (dataResponse.response?.url?.absoluteString ?? ""))
                }
                
                if logOptions.contains(.dataResponse) {
                    print(dataResponse)
                }
                
                if logOptions.contains(.error) || logOptions.contains(.responseData) {
                    print("[RESPONSE DATA]")
                    print(json ?? data)
                }
            }
            
        case .failure(let afError):
            error = AppError.map(afError)
        }
        
        throw error
    }
    
    open func handleRequestError<U: JSONData>(_ error: AppError,
                                              input: APIInputBase) throws -> AnyPublisher<APIResponse<U>, AppError> {
        throw error
    }
    
    open func handleResponseError<U: JSONData>(dataResponse: DataResponse<Data, AFError>, json: U?) -> AppError {
        if let jsonDictionary = json as? JSONDictionary {
            return handleResponseError(dataResponse: dataResponse, json: jsonDictionary)
        } else if let jsonArray = json as? JSONArray {
            return handleResponseError(dataResponse: dataResponse, json: jsonArray)
        }
        
        return handleResponseUnknownError(dataResponse: dataResponse)
    }
    
    open func handleResponseError(dataResponse: DataResponse<Data, AFError>, json: JSONDictionary?) -> AppError {
        
        AppError.serverError(serverFailure: ServerFailure.init(statusCode: dataResponse.response?.statusCode, description: nil))
    }
    
    open func handleResponseError(dataResponse: DataResponse<Data, AFError>, json: JSONArray?) -> AppError {
        AppError.serverError(serverFailure: ServerFailure.init(statusCode: dataResponse.response?.statusCode, description: nil))
    }
    
    open func handleResponseUnknownError(dataResponse: DataResponse<Data, AFError>) -> AppError {
        AppError.serverError(serverFailure: ServerFailure.init(statusCode: dataResponse.response?.statusCode, description: nil))
    }
}

