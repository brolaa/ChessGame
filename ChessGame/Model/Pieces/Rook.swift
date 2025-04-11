//
//  Rook.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import Foundation

struct Rook: ChessPiece, PromotionPiece {
    let name = "rook"
    let color: PlayerColor
    let points = 5
    var hasMoved = false
    var wasPromoted = false
    
    var enemyColor: PlayerColor {
        return color == .white ? .black : .white
    }
    
    func generateMoves(at square: Square, board: Board) -> [ChessMove] {
        var legalMoves: [ChessMove] = []

        // moves to right
        for col in (square.col + 1)..<8 {
            let move = ChessMove(from: square, to: Square(row: square.row, col: col))
            if !board.isSquareOccupaied(move.to) || board.isSquareOccupaiedByEnemyKing(move.to, enemyColor: enemyColor) {
                legalMoves.append(move)
            } else {
                if board.isSquareOccupaiedByEnemy(move.to, enemyColor: enemyColor) {
                    legalMoves.append(move)
                }
                break
            }
        }
        
        // moves to the left
        for col in (0..<square.col).reversed() {
            let move = ChessMove(from: square, to: Square(row: square.row, col: col))
            if !board.isSquareOccupaied(move.to) || board.isSquareOccupaiedByEnemyKing(move.to, enemyColor: enemyColor){
                legalMoves.append(move)
            } else {
                if board.isSquareOccupaiedByEnemy(move.to, enemyColor: enemyColor) {
                    legalMoves.append(move)
                }
                break
            }
        }
        
        // moves upward
        for row in (0..<square.row).reversed() {
            let move = ChessMove(from: square, to: Square(row: row, col: square.col))
            if !board.isSquareOccupaied(move.to) || board.isSquareOccupaiedByEnemyKing(move.to, enemyColor: enemyColor) {
                legalMoves.append(move)
            } else {
                if board.isSquareOccupaiedByEnemy(move.to, enemyColor: enemyColor) {
                    legalMoves.append(move)
                }
                break
            }
        }
        
        // moves downward
        for row in (square.row + 1)..<8 {
            let move = ChessMove(from: square, to: Square(row: row, col: square.col))
            if !board.isSquareOccupaied(move.to) || board.isSquareOccupaiedByEnemyKing(move.to, enemyColor: enemyColor) {
                legalMoves.append(move)
            } else {
                if board.isSquareOccupaiedByEnemy(move.to, enemyColor: enemyColor) {
                    legalMoves.append(move)
                }
                break
            }
        }
        
        return legalMoves
    }
}

