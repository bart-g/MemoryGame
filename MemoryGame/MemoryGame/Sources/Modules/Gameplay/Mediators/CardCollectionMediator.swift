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

protocol CardCollectionMediating: AnyObject {
    func use(collectionView: UICollectionView)
    func use(actionHandler: CardCollectionActionHandling)
    func update(with game: Game)
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
    private var game: Game!
    private var cards: [CardCollectionElement] = []
    private var currentlySelectedCards: [(IndexPath, CardType)] = []
    private var matchedCards: [CardType] = []
    private var isTimerOn = false
    
    init(
        screen: UIScreen,
        gameType: GameType.Type
    ) {
        self.screen = screen
        self.gameType = gameType
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
        self.cards = game.cards.enumerated().map { index, card in
            .init(
                item: .card(.init(frontImage: getFrongImage(for: card))),
                action: .presentCard(card, index)
            )
        }
        
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
    
    private func getFrongImage(for cardType: CardType) -> UIImage {
        switch cardType {
        case .bat:
            return #imageLiteral(resourceName: "Bat")
        case .cat:
            return #imageLiteral(resourceName: "Cat")
        case .cow:
            return #imageLiteral(resourceName: "Cow")
        case .dragon:
            return #imageLiteral(resourceName: "Dragon")
        case .garbage:
            return #imageLiteral(resourceName: "GarbageMan")
        case .ghost:
            return #imageLiteral(resourceName: "GhostDog")
        case .hen:
            return #imageLiteral(resourceName: "Hen")
        case .horse:
            return #imageLiteral(resourceName: "Horse")
        case .pig:
            return #imageLiteral(resourceName: "Pig")
        case .spider:
            return #imageLiteral(resourceName: "Spider")
        }
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
        cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = cards[indexPath.row].item
        
        switch item {
        case .card(let renderable):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! CardCollectionViewCell
            cell.render(cardRenderable: renderable)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        actionHandler.handle(action: cards[indexPath.row].action)
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
            gameType: GameType.self
        )
    }
}
