//
//  GameBuildingMock.swift
//  MemoryGameTests
//
//  Created by Bartosz Górka on 29/08/2021.
//

@testable import MemoryGame
import Foundation

final class GameBuildingMock: GameBuilding {
    
    var buildForGameTypeCallsCount = 0
    var receivedGameType: GameType?
    var gameToReturn: Game = .init(gameType: .fiveTimesTwo, cards: [], uniqueCardCount: 0)
    
    func build(for gameType: GameType) -> Game {
        buildForGameTypeCallsCount += 1
        receivedGameType = gameType
        
        return gameToReturn
    }
}
