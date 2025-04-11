//
//  Pawn.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import Foundation

struct Pawn: ChessPiece {
    let name = "pawn"
    let color: PlayerColor
    let points = 1
    var hasMoved = false
    
    var enemyColor: PlayerColor {
        return color == .white ? .black : .white
    }
    
    var direction: Int {
        return color == .white ? -1 : 1
    }
    
    func generateMoves(at square: Square, board: Board) -> [ChessMove] {
        var moves = [ChessMove]()
        
        let singleMove = Square(row: square.row + direction, col: square.col)
                
        if board.isSquareInsideChessboard(singleMove) && !board.isSquareOccupaied(singleMove) {
            moves.append(ChessMove(from: square, to: singleMove))
            
            // Initial two-square move
            let initialTwoSquareMove = Square(row: square.row + (2 * direction), col: square.col)
            if !hasMoved &&
                board.isSquareInsideChessboard(initialTwoSquareMove) &&
                !board.isSquareOccupaied(initialTwoSquareMove) {
                moves.append(ChessMove(from: square, to: initialTwoSquareMove))
            }
        }
        
        // Capture diagonally
        moves += generateCaptures(at: square, board: board)
        
        // En passant (assuming you have a mechanism to track the last move)
        if let enPassantSquare = board.enPassantSquare {
            if enPassantSquare == Square(row: square.row + direction, col: square.col - 1) {
                // check right
                moves.append(ChessMove(from: square, to: enPassantSquare))
            } else if enPassantSquare == Square(row: square.row + direction, col: square.col + 1) {
                // check left
                moves.append(ChessMove(from: square, to: enPassantSquare))
            }
        }
        
        return moves
    }
    
    func generateCaptures(at square: Square, board: Board) -> [ChessMove] {
        var moves = [ChessMove]()
        
        let captureLeft = Square(row: square.row + direction, col: square.col - 1)
        if board.isValidPawnCapture(captureLeft, enemyColor: enemyColor) {
            moves.append(ChessMove(from: square, to: captureLeft))
        }
        
        let captureRight = Square(row: square.row + direction, col: square.col + 1)
        if board.isValidPawnCapture(captureRight, enemyColor: enemyColor) {
            moves.append(ChessMove(from: square, to: captureRight))
        }
        
        return moves
    }
}
