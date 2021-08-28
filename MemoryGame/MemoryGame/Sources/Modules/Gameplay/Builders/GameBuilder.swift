//
//  GameBuilder.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

protocol GameBuilding {
    func build(for gameType: GameType) -> Game
}

final class GameBuilder: GameBuilding {
    
    private let cardsProvider: CardsProviding
    
    init(
        cardsProvider: CardsProviding
    ) {
        self.cardsProvider = cardsProvider
    }
    
    func build(for gameType: GameType) -> Game {
        var cards = cardsProvider.getCards()
        let numberOfCardsForGame = (gameType.numberOfColumns * gameType.numberOfRows) / 2
        
        guard cards.count >= numberOfCardsForGame else {
            return .init(gameType: gameType, cards: [], uniqueCardCount: 0)
        }
        
        var cardsForGame: [CardType] = []
        
        (0..<numberOfCardsForGame).forEach { _ in
            cardsForGame.append(cards.removeFirst())
        }
        
        cardsForGame += cardsForGame
        cardsForGame.shuffle()
        
        return .init(gameType: gameType, cards: cardsForGame, uniqueCardCount: numberOfCardsForGame)
    }
}
