//
//  GameplayInteraction.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import UIKit

protocol GameplayInteracting: CardCollectionActionHandling, GameControllerDelegate {
    func use(cardCollectionMediator: CardCollectionMediating)
    func use(progressAnimator: ProgressAnimating)
    func use(gameplayRenderer: GameplayRendering)
    func didLoad()
    func didTapBackButton()
}

final class GameplayInteraction: GameplayInteracting {
    
    private enum Constants {
        static let completeProgress: CGFloat = 1.0
        static let timeFormat = "%02d:%02d"
        static let timerTimeInverval = 1.0
    }
   
    private weak var progressAnimator: ProgressAnimating!
    private weak var cardCollectionMediator: CardCollectionMediating!
    private weak var gameplayRenderer: GameplayRendering!
    private let gameType: GameType
    private let navigation: GameplayNavigating
    private let gameController: GameControlling
    private let timer: Timer.Type
    
    private var gameTimer: Timer?
    private var currendSeconds: Int = 0
    
    init(
        gameType: GameType,
        navigation: GameplayNavigating,
        gameController: GameControlling,
        timer: Timer.Type
    ) {
        self.gameType = gameType
        self.navigation = navigation
        self.gameController = gameController
        self.timer = timer
        
        gameController.use(delegate: self)
    }
    
    func use(cardCollectionMediator: CardCollectionMediating) {
        self.cardCollectionMediator = cardCollectionMediator
    }
    
    func use(progressAnimator: ProgressAnimating) {
        self.progressAnimator = progressAnimator
    }
    
    func use(gameplayRenderer: GameplayRendering) {
        self.gameplayRenderer = gameplayRenderer
    }
    
    func didLoad() {
        gameController.startGame(with: gameType)
        renderTime()
    }
    
    func didTapBackButton() {
        navigation.pop()
    }
    
    func handle(action: CardCollectionItemAction) {
        switch action {
        case .presentCard(let cardType, let index):
            gameController.didSelect(card: cardType, at: index)
        }
    }
    
    private func renderTime() {
        let seconds: Int = currendSeconds % 60
        let minutes: Int = (currendSeconds / 60) % 60
        let timeString =  String(format: Constants.timeFormat, minutes, seconds)
        
        gameplayRenderer.render(gameplayTimeRenderable: .init(timeString: timeString))
    }
    
    private func invalidateTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
}

extension GameplayInteraction {
    func didStart(game: Game) {
        cardCollectionMediator.update(with: game)
        gameTimer = timer.scheduledTimer(
            withTimeInterval: Constants.timerTimeInverval,
            repeats: true,
            block: { [weak self] _ in
                self?.currendSeconds += 1
                self?.renderTime()
            }
        )
    }
    
    func didMatch(card: CardType, with progress: CGFloat) {
        progressAnimator.animateProgress(percentage: progress)
        
        guard progress == Constants.completeProgress else { return }
          
        gameplayRenderer.render(gameplayRenderable: .init(isConfettiHidden: false))
        invalidateTimer()
    }
    
    func didNotMatch() {
        progressAnimator.animateDidNotMatch()
    }
    
    func selectCard(at index: Int) {
        cardCollectionMediator.presentCard(at: index)
    }
    
    func deselect(at index: Int) {
        cardCollectionMediator.hideCard(at: index)
    }
}

struct GameplayInteractionAssembler {
    func assemble(
        gameType: GameType,
        navigation: GameplayNavigating
    ) -> GameplayInteracting {
        return GameplayInteraction(
            gameType: gameType,
            navigation: navigation,
            gameController: GameControllerAssembler().assemble(),
            timer: Timer.self
        )
    }
}
