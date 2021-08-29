//
//  TimerProtocolMock.swift
//  MemoryGameTests
//
//  Created by Bartosz Górka on 29/08/2021.
//

@testable import MemoryGame
import Foundation

final class TimerProtocolMock: TimerProtocol {
    
    static var scheduledTimerCallsCount = 0
    static var receivedBlock: ((Timer) -> Void)?
    static var receivedTimeInterval: TimeInterval?
    
    static func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        scheduledTimerCallsCount += 0
        receivedBlock = block
        
        return Timer()
    }
}
