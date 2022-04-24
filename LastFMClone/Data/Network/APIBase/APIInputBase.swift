//
//  APIInputBase.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Foundation
import Alamofire


/// `APIInputBase` have infos about input and service that should be called

open class APIInputBase {
    public var headers: HTTPHeaders?
    public var urlString: String
    public var method: HTTPMethod
    public var encoding: ParameterEncoding
    public var parameters: Parameters?
    public var requireAPIKey: Bool
    public var accessToken: String?
    
    public var usingCache: Bool = false {
        didSet {
            if method != .get {
                fatalError() 
            }
        }
    }
    
    public init(urlString: String,
                parameters: Parameters?,
                method: HTTPMethod,
                requireAPIKey: Bool) {
        self.urlString = urlString
        self.parameters = parameters
        self.method = method
        self.encoding = method == .get ? URLEncoding.default : JSONEncoding.default
        self.requireAPIKey = requireAPIKey
    }
    
}

extension APIInputBase {
    open var urlEncodingString: String {
        guard
            let url = URL(string: urlString),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let parameters = parameters,
            method == .get
        else {
            return urlString
        }
        
        urlComponents.queryItems = []
        
        for name in parameters.keys.sorted() {
            if let value = parameters[name] {
                let item = URLQueryItem(
                    name: "\(name)",
                    value: "\(value)"
                )
                
                urlComponents.queryItems?.append(item)
            }
        }
        
        return urlComponents.url?.absoluteString ?? urlString
    }
    
    open func description(isIncludedParameters: Bool) -> String {
        if method == .get || !isIncludedParameters {
            return "🌎 \(method.rawValue) \(urlEncodingString)"
        }
        
        return [
            "🌎 \(method.rawValue) \(urlString)",
            "Parameters: \(String(describing: parameters ?? JSONDictionary()))"
        ]
        .joined(separator: "\n")
    }
}
