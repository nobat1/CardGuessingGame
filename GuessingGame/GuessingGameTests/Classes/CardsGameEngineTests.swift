//
//  CardsGameEngineTests.swift
//  CardsGameEngineTests
//
//  Created by Nobat on 16/10/19.
//  Copyright © 2019 Nobat. All rights reserved.
//

import XCTest
@testable import GuessingGame

class CardsGameEngineStub: CardsGameEngine {
    
    var shuffledCards = [Card]()
    
    init(with cards: [Card], shuffledCards: [Card]) {
        self.shuffledCards = shuffledCards
        super.init(with: cards)
    }
    
    override func shuffledCards(_ cards: [Card]) -> [Card] {
        return shuffledCards
    }
}

class CardsGameEngineTests: XCTestCase {
    
    private var sut: CardsGameEngineStub!
    
    override func tearDown() {
        sut = nil
    }
    
    // MARK: Test for SUT init
    func test_Initialization() {
        // Given
        let mockCards = getMockShuffledCards_Where2ndCardIsHigher()
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: mockCards)
        
        // When
        // This step is done in setUp()
        
        // Then
        
        // Assert if cards don't match with what was passed to the initiliser
        XCTAssertEqual(mockCards.count, sut.cards.count)
        XCTAssertEqual(mockCards[0], sut.cards[0])
        XCTAssertEqual(mockCards[1], sut.cards[1])
        XCTAssertEqual(mockCards[2], sut.cards[2])
        XCTAssertEqual(mockCards[3], sut.cards[3])
        
        // Assert if currentCard is not nil
        XCTAssertNotNil(sut.currentCard)
        
        // Zero points at the start of the game
        XCTAssertEqual(sut.points, 0)
        
        // Game over should be false
        XCTAssertFalse(sut.isGameOver)
    }
    
    // MARK: Tests for User guess actions
    func test_UserGuessHigher_CardIsHigher() {
        // given
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: getMockShuffledCards_Where2ndCardIsHigher())
        
        // when
        do {
            let result = try sut.nextCardGuess(.higher)
            
            // then
            XCTAssertTrue(result)
            XCTAssertFalse(sut.isGameOver)
            XCTAssertEqual(sut.points, 1)
        } catch {
            assertionFailure("Something unexpected happend")
        }
    }
    
    func test_UserGuessHigher_CardIsLower() {
        // given
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: getMockShuffledCards_Where2ndCardIsLower())
        
        // when
        do {
            let result = try sut.nextCardGuess(.higher)
            
            // then
            XCTAssertFalse(result)
            XCTAssertTrue(sut.isGameOver)
            XCTAssertEqual(sut.points, 0)
        } catch {
            assertionFailure("Something unexpected happend")
        }
    }
    
    func test_UserGuessLower_CardIsHigher() {
        // given
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: getMockShuffledCards_Where2ndCardIsHigher())
        
        // when
        do {
            let result = try sut.nextCardGuess(.lower)
            
            // then
            XCTAssertFalse(result)
            XCTAssertTrue(sut.isGameOver)
            XCTAssertEqual(sut.points, 0)
        } catch {
            assertionFailure("Something unexpected happend")
        }
    }
    
    func test_UserGuessLower_CardIsLower() {
        // given
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: getMockShuffledCards_Where2ndCardIsLower())
        
        // when
        do {
            let result = try sut.nextCardGuess(.lower)
            
            // then
            XCTAssertTrue(result)
            XCTAssertFalse(sut.isGameOver)
            XCTAssertEqual(sut.points, 1)
        } catch {
            assertionFailure("Something unexpected happend")
        }
    }
    
    func test_UserGuessLower_CardIsSameNumberButLowerSuit() {
        // given
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: getMockShuffledCards_Where2ndCardIsSameButLowerSuit())
        
        // when
        do {
            let result = try sut.nextCardGuess(.lower)
            
            // then
            XCTAssertTrue(result)
            XCTAssertFalse(sut.isGameOver)
            XCTAssertEqual(sut.points, 1)
        } catch {
            assertionFailure("Something unexpected happend")
        }
    }
    
    func test_UserGuessLower_CardIsSameNumberButHigherSuit() {
        // given
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: getMockShuffledCards_Where2ndCardIsSameButHigherSuit())
        
        // when
        do {
            let result = try sut.nextCardGuess(.lower)
            
            // then
            XCTAssertFalse(result)
            XCTAssertTrue(sut.isGameOver)
            XCTAssertEqual(sut.points, 0)
        } catch {
            assertionFailure("Something unexpected happend")
        }
    }
    
    func test_UserGuessHigher_CardIsSameNumberButLowerSuit() {
        // given
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: getMockShuffledCards_Where2ndCardIsSameButLowerSuit())
        
        // when
        do {
            let result = try sut.nextCardGuess(.higher)
            
            // then
            XCTAssertFalse(result)
            XCTAssertTrue(sut.isGameOver)
            XCTAssertEqual(sut.points, 0)
        } catch {
            assertionFailure("Something unexpected happend")
        }
    }
    
    func test_UserGuessHigher_CardIsSameNumberButHigherSuit() {
        // given
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: getMockShuffledCards_Where2ndCardIsSameButHigherSuit())
        
        // when
        do {
            let result = try sut.nextCardGuess(.higher)
            
            // then
            XCTAssertTrue(result)
            XCTAssertFalse(sut.isGameOver)
            XCTAssertEqual(sut.points, 1)
        } catch {
            assertionFailure("Something unexpected happend")
        }
    }
    
    // MARK: Tests for game over
    func test_GameOver_2Cards() {
        // given
        let shuffledCards = [
            Card(.king, of: .spades),
            Card(.king, of: .hearts)
        ]
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: shuffledCards)
        
        let gameOverExpectation = expectation(description: "game over")
        sut.gameOverCallback = { _ in
            gameOverExpectation.fulfill()
        }
        
        // when
        do {
            try sut.nextCardGuess(.lower)
        } catch {
            assertionFailure("Something unexpected happend")
        }
        
        // then
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertTrue(self.sut.isGameOver)
            XCTAssertEqual(self.sut.points, 1)
        }
    }
    
    func test_GameOver_10Cards() {
        // given
        let shuffledCards = [
            Card(.king, of: .spades),
            Card(.two, of: .hearts),
            Card(.eight, of: .diamonds),
            Card(.ten, of: .clubs),
            Card(.nine, of: .hearts),
            Card(.three, of: .hearts),
            Card(.three, of: .spades),
            Card(.seven, of: .spades),
            Card(.four, of: .hearts),
            Card(.six, of: .diamonds)
        ]
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: shuffledCards)
        
        let gameOverExpectation = expectation(description: "game over")
        sut.gameOverCallback = { _ in
            gameOverExpectation.fulfill()
        }
        
        // when
        do {
            try sut.nextCardGuess(.lower)
            try sut.nextCardGuess(.higher)
            try sut.nextCardGuess(.higher)
            try sut.nextCardGuess(.lower)
            try sut.nextCardGuess(.lower)
            try sut.nextCardGuess(.higher)
            try sut.nextCardGuess(.higher)
            try sut.nextCardGuess(.lower)
            try sut.nextCardGuess(.higher)
        } catch {
            assertionFailure("Something unexpected happened in the game")
        }
        
        // then
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertTrue(self.sut.isGameOver)
            XCTAssertEqual(self.sut.points, 9)
        }
    }
    
    func test_4Cards_GuessAfterGameOver_ThrowsGameOverException() {
        // given
        let shuffledCards = [
            Card(.king, of: .spades),
            Card(.king, of: .hearts),
            Card(.seven, of: .spades),
            Card(.four, of: .hearts),
        ]
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: shuffledCards)
        
        do {
            // when
            try sut.nextCardGuess(.lower)
            try sut.nextCardGuess(.lower)
            try sut.nextCardGuess(.lower)
            try sut.nextCardGuess(.lower)
            assertionFailure("This should not be executed. Above line should have thrown an error and catch block should be executed.")
        } catch CardsGameEngineStub.GameError.gameOver {
            // then
            XCTAssertEqual(sut.points, 3)
            XCTAssertTrue(sut.isGameOver)
        } catch {
            assertionFailure("It should have executed the gameOver catch block")
        }
    }
    
    func test_4Cards_WrongGuess_GameOver() {
        // given
        let shuffledCards = [
            Card(.king, of: .spades),
            Card(.king, of: .hearts),
            Card(.seven, of: .spades),
            Card(.four, of: .hearts),
        ]
        sut = CardsGameEngineStub(with: getMockCards(), shuffledCards: shuffledCards)
        
        let gameOverExpectation = expectation(description: "game over")
        sut.gameOverCallback = { _ in
            gameOverExpectation.fulfill()
        }
        
        do {
            // when
            try sut.nextCardGuess(.higher)
        } catch {
            // then
            // Do nothing!
        }
        
        // then
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertTrue(self.sut.isGameOver)
            XCTAssertEqual(self.sut.points, 0)
        }
    }
}

// MARK: Mock cards data
extension CardsGameEngineTests {
    
    private func getMockCards() -> [Card] {
        return [
            Card(.ace, of: .spades),
            Card(.two, of: .diamonds),
            Card(.king, of: .hearts),
            Card(.queen, of: .clubs)
        ]
    }
    
    private func getMockShuffledCards_Where2ndCardIsHigher() -> [Card] {
        return [
            Card(.ace, of: .spades),
            Card(.king, of: .hearts),
            Card(.queen, of: .clubs),
            Card(.two, of: .diamonds)
        ]
    }
    
    private func getMockShuffledCards_Where2ndCardIsLower() -> [Card] {
        return [
            Card(.king, of: .hearts),
            Card(.ace, of: .spades),
            Card(.queen, of: .clubs),
            Card(.two, of: .diamonds)
        ]
    }
    
    private func getMockShuffledCards_Where2ndCardIsSameButHigherSuit() -> [Card] {
        return [
            Card(.king, of: .hearts),
            Card(.king, of: .spades),
            Card(.queen, of: .clubs),
            Card(.two, of: .diamonds)
        ]
    }
    
    private func getMockShuffledCards_Where2ndCardIsSameButLowerSuit() -> [Card] {
        return [
            Card(.king, of: .spades),
            Card(.king, of: .hearts),
            Card(.queen, of: .clubs),
            Card(.two, of: .diamonds)
        ]
    }
}
