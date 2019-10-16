//
//  GameViewController.swift
//  GuessingGame
//
//  Created by Nobat on 16/10/19.
//  Copyright © 2019 Nobat. All rights reserved.
//

import UIKit

// TODO: Convert this to MVVM to better isolate responsibilities from view controller to view model
class GameViewController: UIViewController {

    // MARK: Public properties

    // MARK: Private properties
    private var downloadedCards = [Card]()
    private var gameEngine: CardsGameEngine!
    
    // MARK: IBOutlets
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    // TODO: Create a custom view to display the card
    @IBOutlet weak var cardView: UIView!
    @IBOutlet var cardTitleLabels: [UILabel]!
    @IBOutlet var cardSuitImageViews: [UIImageView]!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.borderWidth = 1
        cardView.layer.cornerRadius = 5
        containerStackView.isHidden = true
        downloadCards()
    }
    
    // MARK: Helper functions
    
    // Downloads the Cards from API
    // TODO: We should add a loader while downloading the cards for the first time. From then onwards, we can use caching or download everytime as per the project requirements.
    private func downloadCards() {
        Webservice().getCards { (response) in
            switch response {
            case .success(let cards):
                self.downloadedCards = cards
                DispatchQueue.main.async {
                    self.startGame(with: cards)
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    private func startGame(with cards: [Card]) {
        gameEngine = CardsGameEngine(with: cards)
        gameEngine.gameOverCallback = { points in
            self.gameOver(with: points)
        }
        statusLabel.text = nil
        updatePoints()
        displayNextCard()
        
        containerStackView.isHidden = false
    }
    
    private func displayNextCard() {
        guard let card = gameEngine.currentCard else { return }
        display(card: card)
    }
    
    private func updateStatusLabel(for guessResult: Bool) {
        statusLabel.text = guessResult ? "Correct guess" : "Wrong guess"
        statusLabel.textColor = guessResult ? .green : .red
    }
    
    private func updatePoints() {
        pointsLabel.text = "Your Points: \(gameEngine.points)"
    }
    
    private func display(card: Card) {
        cardTitleLabels.forEach({ $0.text = card.value.rawValue })
    }
    
    private func userGuessed(_ guess: CardsGameEngine.UserGuessOption) {
        do {
            let guessResult = try gameEngine.nextCardGuess(guess)
            updateStatusLabel(for: guessResult)
            displayNextCard()
            updatePoints()
        } catch CardsGameEngine.GameError.gameOver {
            // Game over
            print("Game over")
            gameOver(with: gameEngine.points)
        } catch {
            // Unknown error
            print("Unexpected over")
        }
    }
    
    private func gameOver(with points: Int) {
        let alert = UIAlertController(title: "Game Over", message: "You scored \(points) points!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { (_) in
            self.startGame(with: self.downloadedCards)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    
    @IBAction func guessHigherButtonTapped(_ sender: UIButton) {
        userGuessed(.higher)
    }
    
    @IBAction func guessLowerButtonTapped(_ sender: UIButton) {
        userGuessed(.lower)
    }
}
