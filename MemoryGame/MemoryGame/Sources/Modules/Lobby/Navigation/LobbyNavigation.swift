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
    
    func use(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func presentGameplay(with gameType: GameType) {

    }
}

struct LobbyNavigationAssembler {
    func assemble() -> LobbyNavigating {
        return LobbyNavigation()
    }
}
