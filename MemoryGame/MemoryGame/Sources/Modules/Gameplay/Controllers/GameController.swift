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
    func didNotMatch()
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
    private var timer: Timer.Type
    private var unmatchedCardsTimer: Timer?

    init(
        gameBuilder: GameBuilding,
        timer: Timer.Type
    ) {
        self.gameBuilder = gameBuilder
        self.timer = timer
    }
    
    func use(delegate: GameControllerDelegate) {
        self.delegate = delegate
    }
    
    func startGame(with gameType: GameType) {
        game = gameBuilder.build(for: gameType)
        
        delegate?.didStart(game: game)
    }
    
    func didSelect(card: CardType, at index: Int) {
        guard unmatchedCardsTimer == nil else { return }
        guard matchedCards.contains(card) == false else { return }
        guard lastSelectedCard?.index != index else { return }
        
        if let lastSelectedCard = lastSelectedCard {
            delegate?.selectCard(at: index)
            
            if card == lastSelectedCard.card {
                handleMatched(card: card)
            } else {
                unmatchedCardsTimer = timer.scheduledTimer(withTimeInterval: Constants.timerDuration, repeats: false, block: { [weak self] _ in
                    self?.handleNotMatchedCards(lastIndex: lastSelectedCard.index, currentIndex: index)
                })
            }
            
            return
        }
        
        lastSelectedCard = (card, index)
        delegate?.selectCard(at: index)
    }
    
    private func handleMatched(card: CardType) {
        matchedCards.append(card)
        delegate?.didMatch(card: card, with: CGFloat(matchedCards.count) / CGFloat(game.uniqueCardCount))
        lastSelectedCard = nil
    }
    
    private func handleNotMatchedCards(lastIndex: Int, currentIndex: Int) {
        delegate?.deselect(at: lastIndex)
        delegate?.deselect(at: currentIndex)
        delegate?.didNotMatch()
        lastSelectedCard = nil
        invalidateTimer()
    }
    
    private func invalidateTimer() {
        unmatchedCardsTimer?.invalidate()
        unmatchedCardsTimer = nil
    }
}

struct GameControllerAssembler {
    func assemble() -> GameControlling {
        return GameController(
            gameBuilder: GameBuilderAssembler().assemble(),
            timer: Timer.self
        )
    }
}
