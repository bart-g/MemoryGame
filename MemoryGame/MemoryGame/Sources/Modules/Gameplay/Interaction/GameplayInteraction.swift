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
    }
   
    private weak var progressAnimator: ProgressAnimating!
    private weak var cardCollectionMediator: CardCollectionMediating!
    private weak var gameplayRenderer: GameplayRendering!
    private let gameType: GameType
    private let gameBuilder: GameBuilding
    private let navigation: GameplayNavigating
    private let gameController: GameControlling
    
    init(
        gameType: GameType,
        gameBuilder: GameBuilding,
        navigation: GameplayNavigating,
        gameController: GameControlling
    ) {
        self.gameType = gameType
        self.gameBuilder = gameBuilder
        self.navigation = navigation
        self.gameController = gameController
        
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
    
    func update(progress: CGFloat) {
        progressAnimator.animateProgress(percentage: progress)
    }
    
    func didStart(game: Game) {
        cardCollectionMediator.update(with: game)
    }
    
    func didMatch(card: CardType, with progress: CGFloat) {
        progressAnimator.animateProgress(percentage: progress)
        
        if progress == Constants.completeProgress {
            gameplayRenderer.render(gameplayRenderable: .init(isConfettiHidden: false))
        }
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
            gameBuilder: GameBuilder(cardsProvider: CardsProvider(cardType: CardType.self)),
            navigation: navigation,
            gameController: GameController(gameBuilder: GameBuilder(cardsProvider: CardsProvider(cardType: CardType.self)))
        )
    }
}
