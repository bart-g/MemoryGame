//
//  GameControllerTests.swift
//  MemoryGameTests
//
//  Created by Bartosz Górka on 29/08/2021.
//

@testable import MemoryGame
import XCTest

final class GameControllerTests: XCTestCase {
    
    private var delegate: GameControllerDelegateMock!
    private var timer: TimerProtocolMock.Type!
    private var gameBuilder: GameBuildingMock!
    private var subject: GameController!
    
    override func setUp() {
        super.setUp()
        
        delegate = GameControllerDelegateMock()
        timer = TimerProtocolMock.self
        timer.scheduledTimerCallsCount = 0
        gameBuilder = GameBuildingMock()
        subject = GameController(
            gameBuilder: gameBuilder,
            timer: timer
        )
        subject.use(delegate: delegate)
    }
    
    func test_startGame_calls_build() {
        // Act
        subject.startGame(with: .fiveTimesTwo)
        
        // Assert
        XCTAssertEqual(gameBuilder.buildForGameTypeCallsCount, 1)
    }
    
    func test_startGame_passes_correct_gameType() {
        // Arrange
        let gameType: GameType = .fiveTimesTwo
        // Act
        subject.startGame(with: gameType)
        
        // Assert
        XCTAssertEqual(gameBuilder.receivedGameType, gameType)
    }
    
    func test_startGame_calls_delegate() {
        // Arrange
        let gameType: GameType = .fiveTimesTwo
        // Act
        subject.startGame(with: gameType)
        
        // Assert
        XCTAssertEqual(delegate.didStartCallsCount, 1)
        XCTAssertEqual(delegate.didStartReceivedGame, gameBuilder.gameToReturn)
    }
    
    func test_didSelect_calls_delegate_select_firstSelectedCard() {
        // Arrange
        let index = 0
        // Act
        subject.didSelect(card: .bat, at: index)
        
        // Assert
        XCTAssertEqual(delegate.selectCardCallsCount, 1)
        XCTAssertEqual(delegate.selectCardReceivedIndex, index)
    }
    
    func test_didSelect_does_not_call_delegate_select_twoTimesSameCardSelected() {
        // Arrange
        let index = 0
        subject.didSelect(card: .bat, at: index)

        // Act
        subject.didSelect(card: .bat, at: index)
        
        // Assert
        XCTAssertEqual(delegate.selectCardCallsCount, 1)
        XCTAssertEqual(delegate.selectCardReceivedIndex, index)
    }
    
    func test_didSelect_calls_delegate_select_secondCardWithDifferentIndex() {
        // Arrange
        let index = 1
        subject.startGame(with: .fiveTimesTwo)
        subject.didSelect(card: .bat, at: 0)

        // Act
        subject.didSelect(card: .bat, at: index)
        
        // Assert
        XCTAssertEqual(delegate.selectCardCallsCount, 2)
        XCTAssertEqual(delegate.selectCardReceivedIndex, index)
    }
    
    func test_didSelect_calls_delegate_didMatchCards() {
        // Arrange
        let index = 1
        let card: CardType = .bat
        let expectedProgress = 1.0 / CGFloat(gameBuilder.gameToReturn.uniqueCardCount)
            subject.startGame(with: .fourTimesFour)
        subject.didSelect(card: card, at: 0)

        // Act
        subject.didSelect(card: card, at: index)
        
        // Assert
        XCTAssertEqual(delegate.didMatchCallsCount, 1)
        XCTAssertEqual(delegate.didMatchReceivedCard, card)
        XCTAssertEqual(delegate.didMatchReceivedProgress, expectedProgress)
    }
}
