//
//  APIResponse.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

/// `APIResponse` Generic type of network reponse

public struct APIResponse<T> {
    public var header: ResponseHeader?
    public var data: T
    
    public init(header: ResponseHeader?, data: T) {
        self.header = header
        self.data = data
    }
}
