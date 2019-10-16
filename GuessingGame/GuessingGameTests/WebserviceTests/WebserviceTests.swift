//
//  WebserviceTests.swift
//  GuessingGame
//
//  Created by Nobat on 16/10/19.
//  Copyright © 2019 Nobat. All rights reserved.
//

import XCTest
import CoreData
@testable import GuessingGame

class MockURLSession: URLSession {
    
    private let mockTask: MockTask
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        mockTask = MockTask(data: data, urlResponse: urlResponse, error: error)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        mockTask.completionHandler = completionHandler
        return mockTask
    }
}

class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let taskError: Error?
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.taskError = error
    }
    
    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler?(self.data, self.urlResponse, self.taskError)
        }
    }
}


class WebserviceTests: XCTestCase {
    
    var sut: Webservice!
    
    // Testing generic get API function
    func test_EndpointHasIncompleteURL_WebserviceReturnsEmptyDataError() {
        // given
        sut = Webservice()
        let endpoint = CardsAPIEndpoint(scheme: "https", host: "", path: "", queryItems: [])
        let apiResponseExpectation = expectation(description: "Cards API Response")
        var responseError: Webservice.ResponseError?
        
        // when
        sut.get(endpoint: endpoint, decodingType: [Card].self) { (result) in
            switch result {
            case .success(_): assertionFailure()
            case .failure(let error): responseError = error
            }
            apiResponseExpectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(responseError, .emptyData)
        }
    }
}

// MARK: - Testing Cards API
extension WebserviceTests {
    
    private func getSubjectUnderTest(json: String) -> Webservice {
        let jsonData = Bundle(for: type(of: self)).getDataFromJSON(in: json)
        let session = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        let sut = Webservice(session: session)
        return sut
    }
    
    func test_GetCards_ResponseIsCardsArrayAndValidData() {
        // given
        sut = getSubjectUnderTest(json: "cards_success")
        
        let apiResponseExpectation = expectation(description: "Cards API Response")
        var responseError: Webservice.ResponseError?
        var downloadedCards: [Card]?
        
        // when
        sut.getCards { (result) in
            switch result {
            case .success(let cards): downloadedCards = cards
            case .failure(let error): responseError = error
            }
            apiResponseExpectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(responseError)
            XCTAssertNotEqual(downloadedCards?.count, 0)
            
            // asserting correct data
            let card = downloadedCards!.first!
            XCTAssertEqual(card.value, .ace)
            XCTAssertEqual(card.suit, .spades)
        }
    }
    
    func test_GetCards_ResponseIsInvalidJSONError() {
        // given
        sut = getSubjectUnderTest(json: "cards_invalid")
        
        let apiResponseExpectation = expectation(description: "Cards API Response")
        var responseError: Webservice.ResponseError?
        var downloadedCards: [Card]?
        
        // when
        sut.getCards { (result) in
            switch result {
            case .success(let cards): downloadedCards = cards
            case .failure(let error): responseError = error
            }
            apiResponseExpectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(responseError, .invalidJSON)
            XCTAssertNil(downloadedCards)
        }
    }
}
