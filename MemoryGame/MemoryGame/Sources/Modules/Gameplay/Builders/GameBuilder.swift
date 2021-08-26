//
//  GameBuilder.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

struct Game {
    let cards: [[CardType]]
}

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
            return .init(cards: [])
        }
        
        
        var cardsForGame: [CardType] = []
        
        (0..<numberOfCardsForGame).forEach { _ in
            cardsForGame.append(cards.removeFirst())
        }
        
        cardsForGame += cardsForGame
        
        var gameplayCards: [[CardType]] = []
        
        (0..<gameType.numberOfRows).forEach { row in
            var rowCards: [CardType] = []
            
            (0..<gameType.numberOfColumns).forEach { column in
                rowCards.append(cardsForGame.removeFirst())
            }
            
            gameplayCards.append(rowCards)
        }
        
        return .init(cards: gameplayCards.shuffled())
    }
}
