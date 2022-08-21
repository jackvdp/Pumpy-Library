//
//  Debouncer.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 07/08/2022.
//

import Foundation

public class Debouncer {
    
    private let timeInterval: TimeInterval = 0.3
    private var timer: Timer?
    
    public typealias Handler = () -> Void
    public var handler: Handler? {
        didSet {
            renewInterval()
        }
    }
    
    public init() {}
    
    private func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] (timer) in
            self?.timeIntervalDidFinish(for: timer)
        }
    }
    
    private func timeIntervalDidFinish(for timer: Timer) {
        guard timer.isValid else {
            return
        }
        timer.invalidate()
        handler?()
        handler = nil
    }
    
}
