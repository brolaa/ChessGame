//
//  Bishop.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import Foundation

struct Bishop: ChessPiece, PromotionPiece {
    let name = "bishop"
    let color: PlayerColor
    let points = 3
    var wasPromoted = false
    
    var enemyColor: PlayerColor {
        return color == .white ? .black : .white
    }
    
    func generateMoves(at square: Square, board: Board) -> [ChessMove] {
        var legalMoves: [ChessMove] = []
        
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
