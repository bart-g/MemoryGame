//
//  LobbyNavigation.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import UIKit

protocol LobbyNavigating {
    func use(navigationController: UINavigationController)
    func presentGameplay(with gameType: GameType)
}

final class LobbyNavigation: LobbyNavigating {
    
    private weak var navigationController: UINavigationController!
    
    private let gameplayAssembler: GameplayAssembling
    
    init(
        gameplayAssembler: GameplayAssembling
    ) {
        self.gameplayAssembler = gameplayAssembler
    }
    
    func use(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func presentGameplay(with gameType: GameType) {
        let gameplayViewController = gameplayAssembler.assemble(
            with: gameType,
            navigationController: navigationController
        )
        
        navigationController.pushViewController(gameplayViewController, animated: true)
    }
}

struct LobbyNavigationAssembler {
    func assemble() -> LobbyNavigating {
        return LobbyNavigation(
            gameplayAssembler: GameplayAssembler()
        )
    }
}
