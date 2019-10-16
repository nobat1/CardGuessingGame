//
//  CardsGameEngine.swift
//  GuessingGame
//
//  Created by Nobat on 16/10/19.
//  Copyright © 2019 Nobat. All rights reserved.
//

import XCTest
@testable import GuessingGame

class EndpointTests: XCTestCase {

    var sut: Endpoint!

    override func tearDown() {
        sut = nil
    }

    func test_EndpointHasCorrectDetails_URLGenerationSuccess() {
        // given
        sut = Endpoint(scheme: "https", host: "google.com", path: "/api/v1", queryItems: [])
        
        // when
        let url = sut.url
        
        // then
        XCTAssertNotNil(url)
        XCTAssertEqual(sut.url, URL(string: "https://google.com/api/v1")!)
    }

    func test_EndpointDoesnotHaveCorrectDetails_URLGenerationFailure() {
        // given
        sut = Endpoint(scheme: "https", host: "google.com", path: "api/v1", queryItems: [])
        
        // when
        let url = sut.url
        
        // then
        XCTAssertNil(url)
    }

}
