//
//  CardFrontImageProvider.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 20/09/2021.
//

import UIKit

protocol CardFrontImageProviding {
    func getFrontImage(for cardType: CardType) -> UIImage
}

final class CardFrontImageProvider: CardFrontImageProviding {
    
    func getFrontImage(for cardType: CardType) -> UIImage {
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
}
