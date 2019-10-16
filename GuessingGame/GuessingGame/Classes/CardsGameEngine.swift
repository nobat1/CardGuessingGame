//
//  CardsGameEngine.swift
//  GuessingGame
//
//  Created by Nobat on 16/10/19.
//  Copyright © 2019 Nobat. All rights reserved.
//

import Foundation

struct Card {
    
    enum Value: String {
        case ace = "A"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case ten = "10"
        case jack = "J"
        case queen = "Q"
        case king = "K"
    }
    
    enum Suit: String {
        case spades
        case hearts
        case diamonds
        case clubs
    }
    
    let value: Value
    let suit: Suit
    
    init(_ value: Value, of suit: Suit) {
        self.value = value
        self.suit = suit
    }
}

extension Card: Decodable { }
extension Card.Value: Decodable { }
extension Card.Suit: Decodable { }

extension Card: Equatable { }

extension Card: Comparable {
    
    static func < (lhs: Card, rhs: Card) -> Bool {
        let lhsValue = getNumericValue(for: lhs.value)
        let rhsValue = getNumericValue(for: rhs.value)
        
        if lhsValue == rhsValue {
            // Check for Suit order
            return lhs.suit < rhs.suit
        } else {
            return lhsValue < rhsValue
        }
    }
  
    private static func getNumericValue(for cardValue: Card.Value) -> Int {
        switch cardValue {
        case .ace: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .jack: return 11
        case .queen: return 12
        case .king: return 13
        }
    }
}

extension Card.Suit: Comparable {
    
    static func < (lhs: Card.Suit, rhs: Card.Suit) -> Bool {
        let lhsValue = getNumericSuitValue(for: lhs)
        let rhsValue = getNumericSuitValue(for: rhs)
        
        return lhsValue < rhsValue
    }
    
    private static func getNumericSuitValue(for suit: Card.Suit) -> Int {
        switch suit {
        case .hearts: return 1
        case .clubs: return 2
        case .diamonds: return 3
        case .spades: return 4
        }
    }
}

class CardsGameEngine {
    
    enum UserGuessOption {
        case higher
        case lower
    }
    
    enum GameError: Error {
        case gameOver
    }
    
    var gameOverCallback: ((_ points: Int) -> Void)?
    
    private(set) var cards: [Card]
    private(set) var currentCard: Card?
    private(set) var points: Int = 0
    private(set) var isGameOver = false
    
    init(with cards: [Card]) {
        self.cards = cards
        
        // Shuffle them
        self.cards = shuffledCards(self.cards)
        
        // This is for when testing in simulator. We can see the cards order and test accordingly.
        print("Cards after shuffling \(self.cards)")
        
        // Assigning first card to currentCard
        currentCard = self.cards.first
    }
    
    // Shuffle the cards randomly
    func shuffledCards(_ cards: [Card]) -> [Card] {
        return cards.shuffled()
    }
    
    @discardableResult
    func nextCardGuess(_ guessOption: UserGuessOption) throws -> Bool {
        guard !isGameOver else {
            // If this is executed then user tried to make a move even after the game is over. Thus, throwing an error
            throw GameError.gameOver
        }
        
        guard
            let currentCard = self.currentCard,
            let currentIndex = cards.firstIndex(of: currentCard)
            else { return false }
        
        let nextCard = cards[currentIndex+1]
        
        self.currentCard = nextCard
        
        var guessResult = false
        
        switch guessOption {
        case .higher: guessResult = nextCard > currentCard
        case .lower: guessResult = nextCard < currentCard
        }
        
        if guessResult { points += 1 }
        
        // checking for game over scenario
        if guessResult == false || nextCard == cards.last {
            // there's no card after the next card. and the next card is the last card in the stack. Thus, game is over
            isGameOver = true
            gameOverCallback?(points)
        }
        
        return guessResult
    }
}
