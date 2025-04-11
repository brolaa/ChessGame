//
//  ChessTimer.swift
//  ChessGame
//
//  Created by Bartosz Rola on 28/12/2024.
//

import Foundation

struct ChessTimer {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private(set) var timerRunning = false
    private(set) var blackTime: Int
    private(set) var whiteTime: Int
    private(set) var updatedColor: PlayerColor = .white
    
    init(time: Int) {
        blackTime = 60 * time
        whiteTime = 60 * time
    }
    
    mutating func changeUpdatedColor(color: PlayerColor) {
        updatedColor = color
    }
    
    mutating func start() {
        timerRunning = true
    }
    
    mutating func stop() {
        timerRunning = false
    }
    
    func turnOff() {
        timer.upstream.connect().cancel()
    }
    
    mutating func update() {
        if updatedColor == .white {
            if whiteTime > 0 {
                whiteTime -= 1
            }
            
            if whiteTime == 0 {
                turnOff()
            }
        } else {
            if blackTime > 0 {
                blackTime -= 1
            }
            
            if blackTime == 0 {
                turnOff()
            }
        }
    }
}
