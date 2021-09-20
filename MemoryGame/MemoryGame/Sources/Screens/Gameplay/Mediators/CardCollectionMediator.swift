//
//  CardCollectionMediator.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import UIKit

protocol CardCollectionActionHandling: AnyObject {
    func handle(action: CardCollectionItemAction)
}

enum CardCollectionItem {
    case card(CardRenderable)
}

enum CardCollectionItemAction {
    case presentCard(CardType, Int)
}

struct CardCollectionElement {
    let item: CardCollectionItem
    let action: CardCollectionItemAction
}

protocol CardCollectionUpdating: AnyObject {
    func update(with game: Game)
}

protocol CardCollectionMediating: CardCollectionUpdating {
    func use(collectionView: UICollectionView)
    func use(actionHandler: CardCollectionActionHandling)
    func presentCard(at index: Int)
    func hideCard(at index: Int)
}

final class CardCollectionMediator: NSObject, CardCollectionMediating, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private enum Constants {
        static let cellIdentifier = String(describing: CardCollectionViewCell.self)
        static let imageSizeMultiplier: CGFloat = 1.4
    }
 
    private weak var actionHandler: CardCollectionActionHandling!
    private weak var collectionView: UICollectionView!
        
    private let screen: UIScreen
    private let gameType: GameType.Type
    private let dataSource: CardCollectionDataSourceProtocol
   
    private var game: Game!
    private var isTimerOn = false
    
    init(
        screen: UIScreen,
        gameType: GameType.Type,
        dataSource: CardCollectionDataSourceProtocol
    ) {
        self.screen = screen
        self.gameType = gameType
        self.dataSource = dataSource
    }
    
    func use(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Constants.cellIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.cellIdentifier)
    }
    
    func use(actionHandler: CardCollectionActionHandling) {
        self.actionHandler = actionHandler
    }
    
    func update(with game: Game) {
        self.game = game
        dataSource.update(with: game)
        setCollectionViewInsets()
        collectionView.reloadData()
    }
    
    func presentCard(at index: Int) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CardCollectionViewCell else { return }
        cell.renderFront()
    }
    
    func hideCard(at index: Int) {
        guard let cell = collectionView.cellForItem(at:  IndexPath(item: index, section: 0)) as? CardCollectionViewCell else { return }
        cell.renderBack()
    }
    
    private func getMaxCardColumnsCount() -> Int {
        gameType.allCases.map({ $0.numberOfColumns }).max() ?? 0
    }
    
    private func setCollectionViewInsets() {
        let screenWidth = screen.bounds.width
        let itemSize = screenWidth / CGFloat(getMaxCardColumnsCount())
        let numberOfRows = CGFloat(game.gameType.numberOfColumns)
        let inset = (screenWidth - itemSize * numberOfRows) / 2
        collectionView.contentInset = .init(top: 0.0, left: inset, bottom: 0.0, right: inset)
    }
}

extension CardCollectionMediator {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource.getItem(at: indexPath)
        
        switch item {
        case .card(let renderable):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! CardCollectionViewCell
            cell.render(cardRenderable: renderable)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = dataSource.getAction(at: indexPath)
        actionHandler.handle(action: action)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = screen.bounds.width
        let size = width / CGFloat(getMaxCardColumnsCount())
        
        return .init(width: size, height: size * Constants.imageSizeMultiplier)
    }
}

struct CardCollectionMediatorAssembler {
    func assemble() -> CardCollectionMediating {
        return CardCollectionMediator(
            screen: UIScreen.main,
            gameType: GameType.self,
            dataSource: CardCollectionDataSourceAssembler().assemble()
        )
    }
}
