//
//  LobbyInteraction.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import Foundation

protocol LobbyInteracting {
    func didTapThreeTimesFourButton()
    func didTapFiveTimesTwoButton()
    func didTapFourTimesFourButtonAction()
    func didTapFourTimesFiveButtonAction()
}

final class LobbyInteraction: LobbyInteracting {
    
    private let navigation: LobbyNavigating
    
    init(
        navigation: LobbyNavigating
    ) {
        self.navigation = navigation
    }
    
    func didTapThreeTimesFourButton() {
        navigation.presentGameplay(with: .threeTimesFour)
    }
    
    func didTapFiveTimesTwoButton() {
        navigation.presentGameplay(with: .fiveTimesTwo)
    }
    
    func didTapFourTimesFourButtonAction() {
        navigation.presentGameplay(with: .fourTimesFour)
    }
    
    func didTapFourTimesFiveButtonAction() {
        navigation.presentGameplay(with: .fourTimesFive)
    }
}

struct LobbyInteractionAssembler {
    func assemble(navigation: LobbyNavigating) -> LobbyInteracting {
        return LobbyInteraction(
            navigation: navigation
        )
    }
}
