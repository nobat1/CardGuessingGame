//
//  CardTests.swift
//  GuessingGameTests
//
//  Created by Nobat on 16/10/19.
//  Copyright © 2019 Nobat. All rights reserved.
//

import XCTest
@testable import GuessingGame

class CardTests: XCTestCase {

    var card: Card!

    override func tearDown() {
        card = nil
    }

    // MARK: Test functions for Spades suit
    func test_Ace_Spades() {
        // given & when
        card = Card(.ace, of: .spades)
        
        // then
        XCTAssertEqual(card.value, .ace)
        XCTAssertEqual(card.suit, .spades)
    }
    
    func test_Queen_Spades() {
        // given & when
        card = Card(.queen, of: .spades)
        
        // then
        XCTAssertEqual(card.value, .queen)
        XCTAssertEqual(card.suit, .spades)
    }
    
    // MARK: Test functions for Hearts suit
    func test_Ace_Hearts() {
        // given & when
        card = Card(.ace, of: .hearts)
        
        // then
        XCTAssertEqual(card.value, .ace)
        XCTAssertEqual(card.suit, .hearts)
    }
    
    func test_Queen_Hearts() {
        // given & when
        card = Card(.queen, of: .hearts)
        
        // then
        XCTAssertEqual(card.value, .queen)
        XCTAssertEqual(card.suit, .hearts)
    }
    
    // MARK: Test functions for Diamonds suit
    func test_Ace_Diamonds() {
        // given & when
        card = Card(.ace, of: .diamonds)
        
        // then
        XCTAssertEqual(card.value, .ace)
        XCTAssertEqual(card.suit, .diamonds)
    }
    
    func test_Queen_Diamonds() {
        // given & when
        card = Card(.queen, of: .diamonds)
        
        // then
        XCTAssertEqual(card.value, .queen)
        XCTAssertEqual(card.suit, .diamonds)
    }
    
    // MARK: Test functions for Clubs suit
    func test_Ace_Clubs() {
        // given & when
        card = Card(.ace, of: .clubs)
        
        // then
        XCTAssertEqual(card.value, .ace)
        XCTAssertEqual(card.suit, .clubs)
    }
    
    func test_Queen_Clubs() {
        // given & when
        card = Card(.queen, of: .clubs)
        
        // then
        XCTAssertEqual(card.value, .queen)
        XCTAssertEqual(card.suit, .clubs)
    }

}
