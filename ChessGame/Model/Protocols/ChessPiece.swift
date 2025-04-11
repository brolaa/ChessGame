//
//  ChessPiece.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import Foundation

protocol ChessPiece {
    var name: String { get }
    var points: Int { get }
    var color: PlayerColor { get }
    
    func generateMoves(at square: Square, board: Board) -> [ChessMove]
}
