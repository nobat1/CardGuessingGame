//
//  Endpoint.swift
//  GuessingGame
//
//  Created by Nobat on 16/10/19.
//  Copyright © 2019 Nobat. All rights reserved.
//

import Foundation

// MARK: Generic Endpoint class

class Endpoint {
    let scheme: String
    let host: String
    let path: String
    let queryItems: [URLQueryItem]
    
    init(scheme: String, host: String, path: String, queryItems: [URLQueryItem]) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}

extension Endpoint {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        if queryItems.count > 0 { components.queryItems = queryItems }
        return components.url
    }
}
