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
    
    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
        static let animationOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
    }

    @IBOutlet private weak var backImageView: UIImageView!
    @IBOutlet private weak var frontImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func render(cardRenderable: CardRenderable) {
        frontImageView.image = cardRenderable.frontImage
    }
    
    func renderFront() {
        animate(
            from: backImageView,
            to: frontImageView
        )
    }

    func renderBack() {
        animate(
            from: frontImageView,
            to: backImageView
        )
    }
    
    private func animate(from fromView: UIView, to toView: UIView) {
        UIView.transition(
            from: fromView,
            to: toView,
            duration: Constants.animationDuration,
            options: Constants.animationOptions,
            completion: nil
        )
    }
}
