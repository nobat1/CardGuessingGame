//
//  Webservice.swift
//  GuessingGame
//
//  Created by Nobat on 16/10/19.
//  Copyright © 2019 Nobat. All rights reserved.
//

import Foundation

class Webservice {
    
    enum ResponseError: Error {
        case invalidURL
        case invalidJSON
        case emptyData
    }
    
    private var session: URLSession!
    init(session: URLSession = URLSession.shared) { self.session = session }
    
    func getCards(_ completion: @escaping ((Result<[Card], ResponseError>) -> Void)) {
        get(endpoint: CardsAPIEndpoint.cards(), decodingType: [Card].self, completion)
    }
}

extension Webservice {
    
    func get<T>(endpoint: Endpoint, decodingType: T.Type,
                _ completion: @escaping ((Result<T, ResponseError>) -> Void)) where T: Decodable {
        
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let genericModel = try decoder.decode(decodingType, from: data)
                completion(.success(genericModel))
            } catch {
                print("URL: \(url)")
                print("JSON Conversion failed: \(error)")
                completion(.failure(.invalidJSON))
            }
        }
        task.resume()
    }
}
