//
//  GameplayInteraction.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import Foundation

protocol GameplayInteracting {
    func use(cardCollectionMediator: CardCollectionMediating)
    func didLoad()
    func didTapBackButton()
}

final class GameplayInteraction: GameplayInteracting {
    
    private weak var cardCollectionMediator: CardCollectionMediating!
    private let gameType: GameType
    private let gameBuilder: GameBuilding
    private let navigation: GameplayNavigating
    
    init(
        gameType: GameType,
        gameBuilder: GameBuilding,
        navigation: GameplayNavigating
    ) {
        self.gameType = gameType
        self.gameBuilder = gameBuilder
        self.navigation = navigation
    }
    
    func use(cardCollectionMediator: CardCollectionMediating) {
        self.cardCollectionMediator = cardCollectionMediator
    }
    
    func didLoad() {
        let game = gameBuilder.build(for: gameType)
        cardCollectionMediator.updateCards(cards: game.cards)
    }
    
    func didTapBackButton() {
        navigation.pop()
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
            navigation: navigation
        )
    }
}
