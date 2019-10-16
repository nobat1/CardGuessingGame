//
//  CardsAPIEndpoint.swift
//  GuessingGame
//
//  Created by Nobat on 16/10/19.
//  Copyright © 2019 Nobat. All rights reserved.
//

import Foundation

// MARK: CardsAPI Endpoint

class CardsAPIEndpoint: Endpoint {
    
    override init(scheme: String = "https",
                  host: String = "cards.davidneal.io",
                  path: String,
                  queryItems: [URLQueryItem] = []) {
        
        super.init(scheme: scheme,
                   host: host,
                   path: "/api/" + path,
                   queryItems: queryItems)
    }
}

extension CardsAPIEndpoint {
    
    static func cards() -> CardsAPIEndpoint {
        CardsAPIEndpoint(path: "cards")
    }
}
