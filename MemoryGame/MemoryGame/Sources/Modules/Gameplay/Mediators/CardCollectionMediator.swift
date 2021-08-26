//
//  CardCollectionMediator.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import UIKit

struct CardRenderable {
}

enum CardCollectionItem {
    case card(CardRenderable)
}

enum CardCollectionItemAction {
    case presentCard
}

struct CardCollectionElement {
    let item: CardCollectionItem
    let action: CardCollectionItemAction
}

protocol CardCollectionDataSourceProtocol {
    func updateCards(cards: [[CardType]])
}

protocol CardCollectionMediating: AnyObject {
    func use(collectionView: UICollectionView)
    func updateCards(cards: [[CardType]])
}

final class CardCollectionMediator: NSObject, CardCollectionMediating, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private weak var collectionView: UICollectionView!
    private var cards: [[CardCollectionElement]] = []
    
    func use(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
    }
    func updateCards(cards: [[CardType]]) {
        (0..<cards.count).forEach { rowIndex in
            var rowCardElements: [CardCollectionElement] = []
            
            (0..<cards[rowIndex].count).forEach { columnIndex in
                rowCardElements.append(
                    .init(
                        item: .card(.init()),
                        action: .presentCard
                    )
                )
            }

            
            self.cards.append(rowCardElements)
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let itemSize = screenWidth / 5
        let numberOfRows = CGFloat(cards.first?.count ?? 0)
        let itemsSize = itemSize * numberOfRows - (numberOfRows - 1) * 10
        let inset = (screenWidth - itemsSize) / 2
        
        collectionView.contentInset = .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cards[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = cards[indexPath.section][indexPath.row].item
        
        switch item {
        case .card(let renderable):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
            cell.backgroundColor = .red
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthMinusSpacing = UIScreen.main.bounds.width - CGFloat((cards.first?.count ?? 0) - 1) * 10.0
        let size = widthMinusSpacing / 5
        return .init(width: size, height: size * 1.4)
    }
}
