//
//  CardsProvider.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import Foundation

protocol CardsProviding {
    func getCards() -> Set<CardType>
}

final class CardsProvider: CardsProviding {
    
    private let cardType: CardType.Type
    
    init(
        cardType: CardType.Type
    ) {
        self.cardType = cardType
    }
    
    func getCards() -> Set<CardType> {
        return  Set(cardType.allCases.shuffled())
    }
}
