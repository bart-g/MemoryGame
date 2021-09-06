//
//  ProgressAnimator.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 28/08/2021.
//

import UIKit

protocol ProgressAnimating: AnyObject {
    func use(backgroundView: UIView)
    func use(progressWidthConstraint: NSLayoutConstraint)
    func animateProgress(percentage: CGFloat)
    func animateDidNotMatch()
}

final class ProgressAnimator: ProgressAnimating {
    
    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
        static let notMatchedCardsColor = UIColor.red
    }
    
    private weak var backgroundView: UIView!
    private weak var progressWidthConstraint: NSLayoutConstraint!
    
    private let view: UIView.Type
    
    init(
        view: UIView.Type
    ) {
        self.view = view
    }
    
    func use(backgroundView: UIView) {
        self.backgroundView = backgroundView
    }
    
    func use(progressWidthConstraint: NSLayoutConstraint) {
        self.progressWidthConstraint = progressWidthConstraint
    }
    
    func animateProgress(percentage: CGFloat) {
        let backgroundViewWidth = backgroundView.frame.width
        let newProgressWidth = backgroundViewWidth * percentage
                
        progressWidthConstraint.constant = newProgressWidth

        view.animate(withDuration: Constants.animationDuration) {
            self.backgroundView.layoutIfNeeded()
        }
    }
    
    func animateDidNotMatch() {
        let initialColor = backgroundView.backgroundColor ?? .white
        
        animateBackgroundView(backgroundColor: Constants.notMatchedCardsColor) { _ in
            self.animateBackgroundView(backgroundColor: initialColor, completion: nil)
        }
    }
    
    private func animateBackgroundView(backgroundColor: UIColor, completion: ((Bool) -> Void)?) {
        view.animate(
            withDuration: Constants.animationDuration,
            animations: {
                self.backgroundView.backgroundColor = backgroundColor
            },
            completion: completion
        )
    }
}


struct ProgressAnimatorAssembler {
    func assemble() -> ProgressAnimating {
        return ProgressAnimator(view: UIView.self)
    }
}
