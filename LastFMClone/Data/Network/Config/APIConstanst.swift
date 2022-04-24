//
//  NetworkConstanst.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import Foundation


/// `APIConstants`  used as network constant utils
struct APIConstants {
    enum RouteType : String{
        case baseHttps = "https://ws.audioscrobbler.com/"
        case baseHttp = "http://ws.audioscrobbler.com/"
        case version = "2.0/"
        
    }
    
    enum ContentType: String {
        case json  = "application/json"
    }
    
    static let responseJsonFormat = "json"
    
    static let baseHttpUrl: String  = "\(RouteType.baseHttp.rawValue)\(RouteType.version.rawValue)"
    static let baseHttpsURL: String = "\(RouteType.baseHttps.rawValue)\(RouteType.version.rawValue)"
}
