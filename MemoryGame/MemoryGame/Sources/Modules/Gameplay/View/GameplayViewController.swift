//
//  GameplayViewController.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import UIKit

final class GameplayViewController: UIViewController {
    
    private enum Constants {
        static let backButtonImageInstets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        static let backButtonImage = #imageLiteral(resourceName: "BackButton")
        static let backButtonImageContentMode = UIView.ContentMode.scaleAspectFit
    }
    
    private let interaction: GameplayInteracting
    
    init(
        interaction: GameplayInteracting
    ) {
        self.interaction = interaction
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        interaction.didLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpNavigationBar()
    }
    
    private func setUp() {
        setUpBackButton()
    }
    
    private  func setUpBackButton() {
        let backButton = UIButton()
        backButton.setImage(Constants.backButtonImage, for: [])
        backButton.addTarget(self, action: #selector(GameplayViewController.didTapBackButton), for: .touchUpInside)
        backButton.imageView?.contentMode = Constants.backButtonImageContentMode
        backButton.imageEdgeInsets = Constants.backButtonImageInstets
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func didTapBackButton() {
        interaction.didTapBackButton()
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
    }
}
 
protocol GameplayAssembling {
    func assemble(
        with gameType: GameType,
        navigationController: UINavigationController
    ) -> UIViewController
}

struct GameplayAssembler: GameplayAssembling {
    func assemble(
        with gameType: GameType,
        navigationController: UINavigationController
    ) -> UIViewController {
        let navigation = GameplayNavigationAssembler().assemble()
        navigation.use(navigationController: navigationController)
        let interaction = GameplayInteractionAssembler().assemble(
            gameType: gameType,
            navigation: navigation
        )
        
        return GameplayViewController(
            interaction: interaction
        )
    }
}
