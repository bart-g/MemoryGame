//
//  LobbyViewController.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import UIKit

final class LobbyViewController: UIViewController {

    @IBOutlet private weak var threeTimesFourButton: UIButton!
    @IBOutlet private weak var fiveTimesTwoButton: UIButton!
    @IBOutlet private weak var fourTimesFourButton: UIButton!
    @IBOutlet private weak var fourTimesFiveButton: UIButton!
    
    private let interaction: LobbyInteracting
    
    init(
        interaction: LobbyInteracting
    ) {
        self.interaction = interaction
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUp()
    }
    
    @IBAction private func threeTimesFourButtonAction(_ sender: Any) {
        interaction.didTapThreeTimesFourButton()
    }
    
    @IBAction private func fiveTimesTwoButtonAction(_ sender: Any) {
        interaction.didTapFiveTimesTwoButton()
    }
    
    @IBAction private func fourTimesFourButtonAction(_ sender: Any) {
        interaction.didTapFourTimesFourButtonAction()
    }
    
    @IBAction private func fourTimesFiveButtonAction(_ sender: Any) {
        interaction.didTapFourTimesFiveButtonAction()
    }
    
    private func setUp() {
        navigationController?.isNavigationBarHidden = true
    }
}

struct LobbyViewControllerAssembler {
    func assemble() -> UIViewController {
        let navigation = LobbyNavigationAssembler().assemble()
        let lobbyViewController = LobbyViewController(
            interaction: LobbyInteractionAssembler().assemble(navigation: navigation)
        )
        let navigationController = UINavigationController(rootViewController: lobbyViewController)
        navigation.use(navigationController: navigationController)
        
        return navigationController
    }
 }
