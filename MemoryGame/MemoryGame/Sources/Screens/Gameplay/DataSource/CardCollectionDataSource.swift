//
//  CardCollectionDataSource.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 20/09/2021.
//

import UIKit

protocol CardCollectionDataSourceProtocol: CardCollectionUpdating {
    var numberOfItemsInSection: Int { get }
    func getItem(at indexPath: IndexPath) -> CardCollectionItem
    func getAction(at indexPath: IndexPath) -> CardCollectionItemAction
}

final class CardCollectionDataSource: CardCollectionDataSourceProtocol {

    var numberOfItemsInSection: Int {
        return cards.count
    }
    
    private var cards: [CardCollectionElement] = []
    private let cardFrontImageProvider: CardFrontImageProviding
    
    init(
        cardFrontImageProvider: CardFrontImageProviding
    ) {
        self.cardFrontImageProvider = cardFrontImageProvider
    }
    
    func update(with game: Game) {
        self.cards = game.cards.enumerated().map { index, card in
            .init(
                item: .card(.init(frontImage: cardFrontImageProvider.getFrontImage(for: card))),
                action: .presentCard(card, index)
            )
        }
    }
    
    func getItem(at indexPath: IndexPath) -> CardCollectionItem {
        cards[indexPath.row].item
    }
    
    func getAction(at indexPath: IndexPath) -> CardCollectionItemAction {
        cards[indexPath.row].action
    }
}

struct CardCollectionDataSourceAssembler {
    func assemble() -> CardCollectionDataSourceProtocol {
        return CardCollectionDataSource(
            cardFrontImageProvider: CardFrontImageProvider()
        )
    }
}
