//
//  GameController.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 28/08/2021.
//

import UIKit

protocol GameControllerDelegate: AnyObject {
    func didStart(game: Game)
    func selectCard(at index: Int)
    func deselect(at index: Int)
    func didMatch(card: CardType, with progress: CGFloat)
}
 
protocol GameControlling {
    func use(delegate: GameControllerDelegate)
    func startGame(with gameType: GameType)
    func didSelect(card: CardType, at index: Int)
}

final class GameController: GameControlling {
    
    private enum Constants {
        static let timerDuration: TimeInterval = 1.0
    }
    
    typealias SelectedCard = (card: CardType, index: Int)
    
    private weak var delegate: GameControllerDelegate?
    
    private let gameBuilder: GameBuilding
    private var lastSelectedCard: SelectedCard?
    private var matchedCards: [CardType] = []
    private var game: Game!
    private var timer: Timer?

    init(
        gameBuilder: GameBuilding
    ) {
        self.gameBuilder = gameBuilder
    }
    
    func use(delegate: GameControllerDelegate) {
        self.delegate = delegate
    }
    
    func startGame(with gameType: GameType) {
        game = gameBuilder.build(for: gameType)
        
        delegate?.didStart(game: game)
    }
    
    func didSelect(card: CardType, at index: Int) {
        guard timer == nil else { return }
        guard matchedCards.contains(card) == false else {
            return
        }
        
        if lastSelectedCard?.index == index {
            lastSelectedCard = nil
            delegate?.deselect(at: index)
            
            return
        }
        
        
        if let lastSelectedCard = lastSelectedCard {
            if lastSelectedCard.index == index {
                self.lastSelectedCard = nil
                delegate?.deselect(at: index)
                
                return
            }
            
            if card == lastSelectedCard.card {
                matchedCards.append(card)
                delegate?.selectCard(at: index)
                delegate?.didMatch(card: card, with: CGFloat(matchedCards.count) / CGFloat(game.uniqueCardCount))
                self.lastSelectedCard = nil
            } else {
                delegate?.selectCard(at: index)
                timer = Timer.scheduledTimer(withTimeInterval: Constants.timerDuration, repeats: false, block: { [weak self] _ in
                    self?.delegate?.deselect(at: lastSelectedCard.index)
                    self?.delegate?.deselect(at: index)
                    self?.lastSelectedCard = nil
                    self?.invalidateTimer()
                })
            }
            
            return
        }
        
        lastSelectedCard = (card, index)
        delegate?.selectCard(at: index)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
