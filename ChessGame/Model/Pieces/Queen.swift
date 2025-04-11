//
//  Quenn.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import Foundation

struct Queen: ChessPiece, PromotionPiece {
    let name = "queen"
    let color: PlayerColor
    let points = 9
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
        
        // moves along the top-right diagonal
        for i in 1..<min(8 - square.row, 8 - square.col) {
            let move = ChessMove(from: square, to: Square(row: square.row + i, col: square.col + i))
            if !board.isSquareOccupaied(move.to) || board.isSquareOccupaiedByEnemyKing(move.to, enemyColor: enemyColor) {
                legalMoves.append(move)
            } else {
                if board.isSquareOccupaiedByEnemy(move.to, enemyColor: enemyColor) {
                    legalMoves.append(move)
                }
                break
            }
        }
        
        // moves along the top-left diagonal
        for i in 1..<min(8 - square.row, square.col + 1) {
            let move = ChessMove(from: square, to: Square(row: square.row + i, col: square.col - i))
            if !board.isSquareOccupaied(move.to) || board.isSquareOccupaiedByEnemyKing(move.to, enemyColor: enemyColor) {
                legalMoves.append(move)
            } else {
                if board.isSquareOccupaiedByEnemy(move.to, enemyColor: enemyColor) {
                    legalMoves.append(move)
                }
                break
            }
        }
        
        // moves along the bottom-right diagonal
        for i in 1..<min(square.row + 1, 8 - square.col) {
            let move = ChessMove(from: square, to: Square(row: square.row - i, col: square.col + i))
            if !board.isSquareOccupaied(move.to) || board.isSquareOccupaiedByEnemyKing(move.to, enemyColor: enemyColor) {
                legalMoves.append(move)
            } else {
                if board.isSquareOccupaiedByEnemy(move.to, enemyColor: enemyColor) {
                    legalMoves.append(move)
                }
                break
            }
        }
        
        // moves along the bottom-left diagonal
        for i in 1..<min(square.row + 1, square.col + 1) {
            let move = ChessMove(from: square, to: Square(row: square.row - i, col: square.col - i))
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
