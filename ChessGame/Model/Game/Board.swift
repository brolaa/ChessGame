//
//  Board.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import Foundation

struct Board {
    private(set) var state: [[ChessPiece?]] = [
        [Rook(color: .black), Knight(color: .black), Bishop(color: .black), Queen(color: .black), King(color: .black), Bishop(color: .black), Knight(color: .black), Rook(color: .black)],
        [Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black)],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white)],
        [Rook(color: .white), Knight(color: .white), Bishop(color: .white), Queen(color: .white), King(color: .white), Bishop(color: .white), Knight(color: .white), Rook(color: .white)]
    ]
    
    private(set) var enPassantSquare: Square?
    private(set) var fullMoveCounter = 1
    private(set) var halfMoveClock = 0
    private(set) var rotated = false
    
    mutating func increaseFullMoveCounter() {
        fullMoveCounter += 1
    }
    
    mutating func increaseHalfMoveClock() {
        halfMoveClock += 1
    }
    
    mutating func resetFullMoveCounter() {
        fullMoveCounter = 0
    }
    
    mutating func resetHalfMoveClock() {
        halfMoveClock = 0
    }
    
    mutating func setEnPassantSquare(_ square: Square?) {
        enPassantSquare = square
    }
    
    mutating func rotateChessboard() {
        rotated.toggle()
    }
    
    mutating func setPiece(at square: Square, piece: ChessPiece?) {
        state[square.row][square.col] = piece
    }
    
    func getPiece(at square: Square) -> ChessPiece? {
        return state[square.row][square.col]
    }
    
    func isSquareInsideChessboard(_ square: Square) -> Bool {
        return (
            (square.row >= 0 && square.row < 8) &&
            (square.col >= 0 && square.col < 8)
        )
    }
    
    func isSquareOccupaied(_ square: Square) -> Bool {
        if state[square.row][square.col] != nil {
            return true
        }
        return false
    }
    
    func isSquareOccupaiedByEnemy(_ square: Square, enemyColor: PlayerColor) -> Bool {
        if let piece = state[square.row][square.col] {
            if piece.color == enemyColor {
                return true
            }
        }
        return false
    }
    
    func isValidPawnCapture(_ square: Square, enemyColor: PlayerColor) -> Bool {
        if (!isSquareInsideChessboard(square)) {
            return false
        }
        
        if (!isSquareOccupaiedByEnemy(square, enemyColor: enemyColor)) {
            return false
        }
        
        return true
    }
    
    func isSquareOccupaiedByEnemyKing(_ square: Square, enemyColor: PlayerColor) -> Bool {
        if let piece = state[square.row][square.col] {
            if piece.color == enemyColor && piece is King {
                return true
            }
        }
        return false
    }
    
    func findKingPostion(color: PlayerColor) -> Square? {
        var found = false
        var rowIndex = -1
        var colIndex = -1
        
        for (i, row) in state.enumerated() {
            // Iterate through columns
            for (j, piece) in row.enumerated() {
                if let piece = piece {
                    if piece is King {
                        if piece.color == color {
                            rowIndex = i
                            colIndex = j
                            found = true
                            break
                        }
                    }
                }
            }
            if found { break }
        }
        
        if found { return Square(row: rowIndex, col: colIndex) }
        
        return nil
    }
    
    func generateRowPathBetween(start: Square, end: Square) -> [Square] {
        let startCol = min(start.col, end.col)
        let endCol = max(start.col, end.col)

        var path: [Square] = []

        for col in (startCol + 1)..<endCol {
            path.append(Square(row: start.row, col: col))
        }

        return path
    }
    
    func generateColumnPathBetween(start: Square, end: Square) -> [Square] {
        let startRow = min(start.row, end.row)
        let endRow = max(start.row, end.row)

        var path: [Square] = []

        for row in (startRow + 1)..<endRow {
            path.append(Square(row: row, col: start.col))
        }

        return path
    }
    
    func generateDiagonalPathBetween(start: Square, end: Square) -> [Square] {
        let rowIncrement = (start.row < end.row) ? 1 : -1
        let colIncrement = (start.col < end.col) ? 1 : -1

        var currentRow = start.row + rowIncrement
        var currentCol = start.col + colIncrement
        
        var path: [Square] = []

        while currentRow != end.row && currentCol != end.col {
            path.append(Square(row: currentRow, col: currentCol))
            currentRow += rowIncrement
            currentCol += colIncrement
        }
        
        return path
    }
}
