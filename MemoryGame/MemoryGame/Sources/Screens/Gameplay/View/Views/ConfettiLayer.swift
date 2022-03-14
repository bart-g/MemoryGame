//
//  ConfettiLayer.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 28/08/2021.
//

import UIKit

final class ConfettiLayer: CAEmitterLayer {
    
    private enum Constants {
        static let images = [#imageLiteral(resourceName: "Star")]
        static let colors = [#colorLiteral(red: 1, green: 0.9450980392, blue: 0.4, alpha: 1), #colorLiteral(red: 0.9568627451, green: 0.7529411765, blue: 0.1843137255, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.4784313725, blue: 0.4705882353, alpha: 1), #colorLiteral(red: 0.3682531118, green: 0.8135145307, blue: 0.9476092458, alpha: 1)]
        static let emitterShape: CAEmitterLayerEmitterShape = CAEmitterLayerEmitterShape.line
        static let cellsRange: ClosedRange<Int> = (0...10)
        static let birthRate: Float = 1.0
        static let lifetime: Float = 10.0
        static let lifetimeRange: Float = 0.0
        static let emissionLongitude: CGFloat = .pi
        static let velocity: CGFloat = .random(in: (100...150))
        static let velocityRange: CGFloat = 1.0
        static let emissionRange: CGFloat = 0.5
        static let spin: CGFloat = 3.5
        static let spinRange: CGFloat = 1.0
        static let scale: CGFloat = 0.5
        static let scaleRange: CGFloat = 0.3
    }
    
    override init() {
        super.init()

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setUp()
    }
    
    private func setUp() {
        emitterShape = Constants.emitterShape
        emitterCells = generateEmitterCells(range: Constants.cellsRange)
    }

    private func generateEmitterCells(range: ClosedRange<Int>) -> [CAEmitterCell] {
        return range.map { _ -> CAEmitterCell in
            let cell = CAEmitterCell()
            cell.color = Constants.colors.randomElement()!.cgColor
            cell.contents = Constants.images.randomElement()!.cgImage
            cell.birthRate = Constants.birthRate
            cell.lifetime = Constants.lifetime
            cell.lifetimeRange = Constants.lifetimeRange
            cell.emissionLongitude = Constants.emissionLongitude
            cell.velocity = Constants.velocity
            cell.velocityRange = Constants.velocityRange
            cell.emissionRange = Constants.emissionRange
            cell.spin = Constants.spin
            cell.spinRange = Constants.spinRange
            cell.scale = Constants.scale
            cell.scaleRange = Constants.scaleRange

            return cell
        }
    }
}
