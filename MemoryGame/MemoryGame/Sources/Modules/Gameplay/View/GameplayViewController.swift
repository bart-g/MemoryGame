//
//  GameplayViewController.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import UIKit

struct GameplayRenderable {
    let isConfettiHidden: Bool
}

protocol GameplayRendering: AnyObject {
    func render(gameplayRenderable: GameplayRenderable)
}

final class GameplayViewController: UIViewController, GameplayRendering {
    
    private enum Constants {
        static let backButtonImageInstets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        static let backButtonImage = #imageLiteral(resourceName: "BackButton")
        static let backButtonImageContentMode = UIView.ContentMode.scaleAspectFit
    }
    
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var progressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressBackgroundView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let interaction: GameplayInteracting
    private let collectionMediator: CardCollectionMediating
    private let progressAnimator: ProgressAnimating
    
    private let confettiLayer = ConfettiLayer()
    
    init(
        interaction: GameplayInteracting,
        collectionMediator: CardCollectionMediating,
        progressAnimator: ProgressAnimating
    ) {
        self.interaction = interaction
        self.collectionMediator = collectionMediator
        self.progressAnimator = progressAnimator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        progressAnimator.use(backgroundView: progressBackgroundView)
        progressAnimator.use(progressWidthConstraint: progressViewWidthConstraint)
        collectionMediator.use(collectionView: collectionView)
        collectionMediator.use(actionHandler: interaction)
        interaction.use(cardCollectionMediator: collectionMediator)
        interaction.use(progressAnimator: progressAnimator)
        interaction.use(gameplayRenderer: self)
        interaction.didLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpNavigationBar()
    }
    
    private func setUp() {
        setUpBackButton()
        setUpConfetti()
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
    
    private func setUpConfetti() {
        confettiLayer.emitterPosition = CGPoint(x: view.frame.midX, y: 0)
        confettiLayer.emitterSize = CGSize(width: view.frame.size.width, height: 2)
        confettiLayer.isHidden = true
        view.layer.addSublayer(confettiLayer)
    }
}

extension GameplayViewController {
    func render(gameplayRenderable: GameplayRenderable) {
        confettiLayer.isHidden = gameplayRenderable.isConfettiHidden
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
            interaction: interaction,
            collectionMediator: CardCollectionMediatorAssembler().assemble(),
            progressAnimator: ProgressAnimatorAssembler().assemble()
        )
    }
}
