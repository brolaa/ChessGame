//
//  Knight.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import Foundation

struct Knight: ChessPiece, PromotionPiece {
    let name = "knight"
    let color: PlayerColor
    let points = 3
    var wasPromoted = false
    
    var enemyColor: PlayerColor {
        return color == .white ? .black : .white
    }
    
    func generateMoves(at square: Square, board: Board) -> [ChessMove] {
        let possibleMoves: [Square] = [
            Square(row: square.row - 2, col: square.col - 1),
            Square(row: square.row - 2, col: square.col + 1),
            Square(row: square.row - 1, col: square.col - 2),
            Square(row: square.row - 1, col: square.col + 2),
            Square(row: square.row + 1, col: square.col - 2),
            Square(row: square.row + 1, col: square.col + 2),
            Square(row: square.row + 2, col: square.col - 1),
            Square(row: square.row + 2, col: square.col + 1)
        ]
                
        let chessboardMoves = possibleMoves.filter { board.isSquareInsideChessboard($0) }
        
        let legalMoves = chessboardMoves.filter {
            !board.isSquareOccupaied($0) || board.isSquareOccupaiedByEnemy($0, enemyColor: enemyColor)
        }
        
        return legalMoves.map({ChessMove(from: square, to: $0)})
    }
}

