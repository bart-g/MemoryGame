//
//  Game.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 28/08/2021.
//

import Foundation

struct Game: Equatable {
    let gameType: GameType
    let cards: [CardType]
    let uniqueCardCount: Int
}
