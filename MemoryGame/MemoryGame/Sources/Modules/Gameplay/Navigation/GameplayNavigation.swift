//
//  GameplayNavigation.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import UIKit

protocol ViewControllerPopping {
    func pop()
}

protocol GameplayNavigating: ViewControllerPopping {
    func use(navigationController: UINavigationController)
}

final class GameplayNavigation: GameplayNavigating {
    
    private weak var navigationController: UINavigationController!
    
    func use(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}

struct GameplayNavigationAssembler {
    func assemble() -> GameplayNavigating {
        return GameplayNavigation()
    }
}
