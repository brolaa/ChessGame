//
//  TimeType.swift
//  ChessGame
//
//  Created by Bartosz Rola on 30/12/2024.
//

import Foundation

enum TimeType: Int, CaseIterable {
    case five = 5
    case ten = 10
    case unlimited = 0
    
    var info: (name: String, icon: String) {
        switch self {
        case .ten:
            return ("Min", "10.circle")
        case .five:
            return ("Min", "5.circle")
        case .unlimited:
            return ("Unlimited", "infinity.circle")
        }
    }
}
