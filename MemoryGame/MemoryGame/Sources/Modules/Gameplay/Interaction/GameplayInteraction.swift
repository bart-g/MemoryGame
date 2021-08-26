//
//  GameplayInteraction.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import Foundation

protocol GameplayInteracting {
    func didLoad()
    func didTapBackButton()
}

final class GameplayInteraction: GameplayInteracting {
    
    private let gameType: GameType
    private let navigation: GameplayNavigating
    
    init(
        gameType: GameType,
        navigation: GameplayNavigating
    ) {
        self.gameType = gameType
        self.navigation = navigation
    }
    
    func didLoad() {
        
    }
    
    func didTapBackButton() {
        navigation.pop()
    }
}

struct GameplayInteractionAssembler {
    func assemble(
        gameType: GameType,
        navigation: GameplayNavigating
    ) -> GameplayInteracting {
        return GameplayInteraction(
            gameType: gameType,
            navigation: navigation
        )
    }
}
