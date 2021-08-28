//
//  CardCollectionViewCell.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 28/08/2021.
//

import UIKit

struct CardRenderable {
    let frontImage: UIImage
}

final class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var backImageView: UIImageView!
    @IBOutlet private weak var frontImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func render(cardRenderable: CardRenderable) {
        frontImageView.image = cardRenderable.frontImage
    }
    
    func renderFront() {
        UIView.transition(
            from: backImageView,
            to: frontImageView,
            duration: 0.3,
            options: [.transitionFlipFromRight, .showHideTransitionViews],
            completion: nil
        )
    }

    func renderBack() {
        UIView.transition(
            from: frontImageView,
            to: backImageView,
            duration: 0.3,
            options: [.transitionFlipFromRight, .showHideTransitionViews],
            completion: nil
        )
    }
}
