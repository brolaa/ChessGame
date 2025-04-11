//
//  King.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import Foundation

struct King: ChessPiece {
    let name = "king"
    let points = 10
    let color: PlayerColor
    
    var hasMoved = false
    
    var enemyColor: PlayerColor {
        return color == .white ? .black : .white
    }
    
    func generateMoves(at square: Square, board: Board) -> [ChessMove] {
        var legalMoves: [ChessMove] = []

        // Possible directions for king moves
        let directions: [(Int, Int)] = [
            (1, 0), (1, 1),
            (0, 1), (-1, 1),
            (-1, 0), (-1, -1),
            (0, -1), (1, -1)
        ]
        
        for direction in directions {
            let newRow = square.row + direction.0
            let newCol = square.col + direction.1

            // Check if the new position is within the board boundaries
            if board.isSquareInsideChessboard(Square(row: newRow, col: newCol)) {
                let move = ChessMove(from: square, to: Square(row: newRow, col: newCol))
                
                if !board.isSquareOccupaied(move.to) ||
                    (board.isSquareOccupaiedByEnemy(move.to, enemyColor: enemyColor) &&
                     !board.isSquareOccupaiedByEnemyKing(move.to, enemyColor: enemyColor)) {
                    legalMoves.append(move)
                }
            }
        }

        return legalMoves
    }
}
