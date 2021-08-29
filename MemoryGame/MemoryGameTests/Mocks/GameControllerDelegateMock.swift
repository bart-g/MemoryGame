//
//  GameControllerDelegateMock.swift
//  MemoryGameTests
//
//  Created by Bartosz Górka on 29/08/2021.
//

@testable import MemoryGame
import UIKit

final class GameControllerDelegateMock: GameControllerDelegate {
    
    var didStartCallsCount = 0
    var didStartReceivedGame: Game?
    
    var selectCardCallsCount = 0
    var selectCardReceivedIndex: Int?
    
    var deselectCallsCount = 0
    var deselectReceivedIndex: Int?
    
    var didMatchCallsCount = 0
    var didMatchReceivedCard: CardType?
    var didMatchReceivedProgress: CGFloat?
    
    var didNotMatchCallsCount = 0
    
    func didStart(game: Game) {
        didStartReceivedGame = game
        didStartCallsCount += 1
    }
    
    func selectCard(at index: Int) {
        selectCardReceivedIndex = index
        selectCardCallsCount += 1
    }
    
    func deselect(at index: Int) {
        deselectReceivedIndex = index
        deselectCallsCount += 1
    }
    
    func didMatch(card: CardType, with progress: CGFloat) {
        didMatchReceivedCard = card
        didMatchReceivedProgress = progress
        didMatchCallsCount += 1
    }
    
    func didNotMatch() {
        didNotMatchCallsCount += 1
    }
}
