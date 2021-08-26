//
//  GameType.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import Foundation

enum GameType {
    case threeTimesFour
    case fiveTimesTwo
    case fourTimesFour
    case fourTimesFive
    
    var numberOfRows: Int {
        switch self {
        case .threeTimesFour:
            return 3
        case .fiveTimesTwo:
            return 5
        case .fourTimesFour, .fourTimesFive:
            return 4
        }
    }
    
    var numberOfColumns: Int {
        switch self {
        case .threeTimesFour:
            return 4
        case .fiveTimesTwo:
            return 2
        case .fourTimesFour:
            return 4
        case .fourTimesFive:
            return 5
        }
    }
}
