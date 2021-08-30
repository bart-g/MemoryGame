//
//  TimerProtocol.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 29/08/2021.
//

import Foundation

protocol TimerProtocol {
    static func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer
}

extension Timer: TimerProtocol {}
