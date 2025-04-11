//
//  CastlingSide.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import Foundation

enum CastlingSide {
    case kingside
    case queenside
    
    var rookCol: Int {
        return (self == .kingside) ? 7 : 0
    }
}
