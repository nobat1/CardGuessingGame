//
//  CardsAPIEndpointTests.swift
//  GuessingGame
//
//  Created by Nobat on 16/10/19.
//  Copyright © 2019 Nobat. All rights reserved.
//

import XCTest
@testable import GuessingGame

class CardsAPIEndpointTests: XCTestCase {

    var sut: CardsAPIEndpoint!

    override func tearDown() {
        sut = nil
    }

    func test_CardsEndpointFunction_HasValidURL() {
        // given, when
        sut = CardsAPIEndpoint.cards()
        
        // then
        let string = "https://cards.davidneal.io/api/cards"
        XCTAssertEqual(sut.url, URL(string: string))
    }

}
