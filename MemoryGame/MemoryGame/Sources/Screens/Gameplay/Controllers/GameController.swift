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
    private var timer: TimerProtocol.Type
    private var notMatchedCardsTimer: Timer?

    init(
        gameBuilder: GameBuilding,
        timer: TimerProtocol.Type
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
        let isTimerNotRunning = notMatchedCardsTimer == nil
        let isCardNotMatched = matchedCards.contains(card) == false
        let isCardNotSelected = lastSelectedCard?.index != index
        
        guard
            isTimerNotRunning,
            isCardNotMatched,
            isCardNotSelected
        else { return }
      
        if let lastSelectedCard = lastSelectedCard {
            delegate?.selectCard(at: index)
            
            if card == lastSelectedCard.card {
                handleMatched(card: card)
            } else {
                notMatchedCardsTimer = timer.scheduledTimer(
                    withTimeInterval: Constants.timerDuration,
                    repeats: false,
                    block: { [weak self] _ in
                        self?.handleNotMatchedCards(lastIndex: lastSelectedCard.index, currentIndex: index)
                    }
                )
            }
            
            return
        }
        
        lastSelectedCard = (card, index)
        delegate?.selectCard(at: index)
    }
    
    private func handleMatched(card: CardType) {
        matchedCards.append(card)
        delegate?.didMatch(
            card: card,
            with: CGFloat(matchedCards.count) / CGFloat(game.uniqueCardCount)
        )
        lastSelectedCard = nil
    }
    
    private func handleNotMatchedCards(lastIndex: Int, currentIndex: Int) {
        [lastIndex, currentIndex].forEach { index in
            delegate?.deselect(at: index)
        }
        delegate?.didNotMatch()
        lastSelectedCard = nil
        invalidateTimer()
    }
    
    private func invalidateTimer() {
        notMatchedCardsTimer?.invalidate()
        notMatchedCardsTimer = nil
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

