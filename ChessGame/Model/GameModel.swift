//
//  GameModel.swift
//  ChessGame
//
//  Created by Bartosz Rola on 31/12/2024.
//

import Foundation

struct GameModel {
    var board = Board()
    var chessTimer: ChessTimer
    
    private(set) var playerColor: PlayerColor = .white
    
    var opponentColor: PlayerColor {
        if playerColor == .white {
            return .black
        } else {
            return .white
        }
    }
    
    var promotionPieces: [ChessPiece] {
        return [
            Queen(color: playerColor, wasPromoted: true),
            Rook(color: playerColor, wasPromoted: true),
            Bishop(color: playerColor, wasPromoted: true),
            Knight(color: playerColor, wasPromoted: true)
        ]
    }
    
    private(set) var whiteCapturedPieces = [String]()
    private(set) var blackCapturedPieces = [String]()
    private(set) var whiteScore = 0
    private(set) var blackScore = 0
    
    let gameHasTime: Bool
    
    init(time: Int) {
        chessTimer = ChessTimer(time: time)
        
        if time == 0 {
            gameHasTime = false
            chessTimer.turnOff()
        } else {
            gameHasTime = true
            chessTimer.start()
        }
    }
    
    mutating func changePlayerColor(_ color: PlayerColor) {
        playerColor = color
    }
    
    mutating func movePiece(_ move: ChessMove) {
        let piece = board.getPiece(at: move.from)
        
        if let piece = piece {
            if piece.color == .black {
                board.increaseFullMoveCounter()
            }
            
            board.increaseHalfMoveClock()
        }
        
        // en passant
        if let enPassantSquare = board.enPassantSquare {
            if let piece = piece as? Pawn {
                if move.to == enPassantSquare {
                    let direction = (piece.color == .white) ? 1 : -1
                    
                    let capturedPieceSquare = Square(row: move.to.row + direction, col: move.to.col)
                    
                    capturePiece(square: capturedPieceSquare)
                    board.setPiece(at: capturedPieceSquare, piece: nil)
                }
            }
        }
        
        board.setEnPassantSquare(nil)
        
        if var piece = piece as? King  {
            // castling
            if move.from.col == 4 && abs(move.from.col - move.to.col) == 2 {
                if move.from.col - move.to.col == 2 {
                    performCastling(side: .queenside, color: piece.color)
                } else {
                    performCastling(side: .kingside, color: piece.color)
                }
                
            } else {
                if !piece.hasMoved {
                    piece.hasMoved = true
                }
                
                capturePiece(square: move.to)
                board.setPiece(at: move.to, piece: piece)
            }
        } else if var piece = piece as? Rook {
            if !piece.hasMoved {
                piece.hasMoved = true
            }
            
            capturePiece(square: move.to)
            board.setPiece(at: move.to, piece: piece)
        } else if var piece = piece as? Pawn {
            // initial two square Pawn move
            if !piece.hasMoved {
                if abs(move.from.row - move.to.row) == 2 {
                    let direction = (piece.color == .white) ? 1 : -1
                    
                    board.setEnPassantSquare(Square(row: move.to.row + direction, col: move.to.col))
                }
                
                piece.hasMoved = true
            }
            
            //reset halfmove clock
            board.resetHalfMoveClock()
            
            capturePiece(square: move.to)
            board.setPiece(at: move.to, piece: piece)
        } else {
            capturePiece(square: move.to)
            board.setPiece(at: move.to, piece: piece)
        }
        
        // remove piece from previous square
        board.setPiece(at: move.from, piece: nil)
    }
    
    
    mutating func promotePawn(move: ChessMove, to piece: ChessPiece) {
        movePiece(move)
        board.setPiece(at: move.to, piece: piece)
    }
    
    mutating func capturePiece(square: Square) {
        if let piece = board.getPiece(at: square) {
            var capturedPiece = piece.name
            var score = piece.points
            
            // piece was promoted
            if let piece = piece as? PromotionPiece {
                if piece.wasPromoted {
                    capturedPiece = "pawn"
                    score = 1
                }
            }
            
            if piece.color == .white {
                blackCapturedPieces.append(capturedPiece)
                blackScore += score
            } else {
                whiteCapturedPieces.append(capturedPiece)
                whiteScore += score
            }
            
            // reset halfmove clock
            board.resetHalfMoveClock()
        }
    }
    
    mutating func performCastling(side: CastlingSide, color: PlayerColor) {
        let row: Int = color == .black ? 0 : 7
        
        let kingSquare = Square(row: row, col: 4)
        let rookSquare = Square(row: row, col: side.rookCol)
        
        guard var king = board.getPiece(at: kingSquare) as? King else {
            return
        }
        
        guard var rook = board.getPiece(at: rookSquare) as? Rook else {
            return
        }
        
        king.hasMoved = true
        rook.hasMoved = true
        
        let direction = side == .kingside ? 1 : -1
        
        board.setPiece(at: kingSquare, piece: nil)
        board.setPiece(at: rookSquare, piece: nil)
        
        let kingSquareMoved = Square(row: kingSquare.row, col: kingSquare.col + direction * 2)
        let rookSquareMoved = Square(row: rookSquare.row, col: kingSquare.col + direction)
        
        board.setPiece(at: kingSquareMoved, piece: king)
        board.setPiece(at: rookSquareMoved, piece: rook)
    }
    
    
    func generateLegalMoves(for selectedSquare: Square?) -> [ChessMove] {
        guard let selectedSquare = selectedSquare, let selectedPiece = board.getPiece(at: selectedSquare) else {
            return []
        }
        
        guard selectedPiece.color == playerColor else {
            return []
        }
        
        return generateLegalMoves(for: selectedSquare, color: playerColor)
    }
    
    func generateLegalMoves(for square: Square, color: PlayerColor) -> [ChessMove] {
        guard let piece = board.getPiece(at: square) else {
            return []
        }
        
        var legalMoves = [ChessMove]()
        
        legalMoves += piece.generateMoves(at: square, board: board)
        
        if piece is King {
            legalMoves = legalMoves.filter({
                !isSquareEnemyKingMove($0.to, color: color) &&
                !moveThreatensKing(move: $0, board: board, color: color)
            })
            
            if canCastle(side: .kingside, color: color, board: board) {
                let move = ChessMove(from: square, to: Square(row: square.row, col: square.col + 2))
                
                legalMoves.append(move)
            }
            
            if canCastle(side: .queenside, color: color, board: board) {
                let move = ChessMove(from: square, to: Square(row: square.row, col: square.col - 2))
                
                legalMoves.append(move)
            }
            
            return legalMoves
        }
        
        let kingSquare = board.findKingPostion(color: color)
        
        guard let kingSquare = kingSquare else { return [] }
        
        if isCheck(color: color, board: board) {
            let enemyColor: PlayerColor = color == .black ? .white : .black
            
            let attackingSquares = generatePossibleCaptures(kingSquare, color: enemyColor, board: board)
            
            legalMoves = legalMoves.filter { move in attackingSquares.contains(where: {$0 == move.to})}
        }
        
        legalMoves = legalMoves.filter { !moveThreatensKing(move: $0, board: board, color: color) }
                
        return legalMoves
    }
    
    func generateAllMoves(color: PlayerColor) -> [ChessMove] {
        var allMoves: [ChessMove] = []
        
        for row in 0..<8 {
            for col in 0..<8 {
                let square = Square(row: row, col: col)
                
                guard let piece = board.getPiece(at: square) else { continue }
                if (piece.color != color) { continue }
                
                allMoves += generateLegalMoves(for: square, color: color)
            }
        }
        
        return allMoves
    }
    
    func generatePossibleCaptures(_ square: Square, color: PlayerColor, board: Board) -> [Square] {
        var attackingSquares = [Square]()
        var foundAttackingSquare = false
        
        for row in 0..<8 {
            for col in 0..<8 {
                let squareForCheck = Square(row: row, col: col)
                
                if let piece = board.getPiece(at: squareForCheck) {
                    if piece.color == color {
                        
                        
                        if let pawn = piece as? Pawn {
                            let captures = pawn.generateCaptures(at: squareForCheck, board: board)
                            
                            if captures.contains(where: { $0.to == square }) {
                                attackingSquares.append(squareForCheck)
                                
                                foundAttackingSquare = true
                                break
                            }
                        } else if !(piece is King) {
                            let captures = piece.generateMoves(at: squareForCheck, board: board)
                            
                            if captures.contains(where: { $0.to == square }) {
                                attackingSquares.append(squareForCheck)
                                
                                if piece is Rook || piece is Queen {
                                    if row == square.row && (abs(col - square.col) > 1) {
                                        let path = board.generateRowPathBetween(start: square, end: squareForCheck)
                                        
                                        attackingSquares += path
                                    } else if col == square.col && (abs(row - square.row) > 1) {
                                        let path = board.generateColumnPathBetween(start: square, end: squareForCheck)
                                        
                                        attackingSquares += path
                                    }
                                }
                                
                                if piece is Bishop || piece is Queen {
                                    if abs(row - square.row) == abs(col - square.col) &&
                                        abs(row - square.row) > 1 && abs(col - square.col) > 1 {
                                        let path = board.generateDiagonalPathBetween(start: square, end: squareForCheck)
                                        
                                        attackingSquares += path
                                    }
                                }
                                
                                foundAttackingSquare = true
                                break
                            }
                        }
                    }
                    
                    if foundAttackingSquare { break }
                }
            }
        }
        
        return attackingSquares
    }
    
    func isCheck(color: PlayerColor, board: Board) -> Bool {
        let kingSquare = board.findKingPostion(color: color)
        
        if let kingSquare = kingSquare {
            let enemyColor: PlayerColor = color == .black ? .white : .black
            
            if isSquareAttacked(kingSquare, color: enemyColor, board: board) {
                return true
            }
        }
        
        return false
    }
    
    func isCheckmate(color: PlayerColor, board: Board) -> Bool {
        if isCheck(color: color, board: board) {
            if generateAllMoves(color: color).isEmpty {
                return true
            }
        }
        
        return false
    }
    
    func isStalemate(color: PlayerColor, board: Board) -> Bool {
        if !isCheck(color: color, board: board) {
            if generateAllMoves(color: color).isEmpty {
                return true
            }
        }
            
        return false
    }
    
    func isSquareAttacked(_ square: Square, color: PlayerColor, board: Board) -> Bool {
        for row in 0..<8 {
            for col in 0..<8 {
                let squareForCheck = Square(row: row, col: col)
                
                if let piece = board.getPiece(at: squareForCheck) {
                    if piece.color == color {
                        if let pawn = piece as? Pawn {
                            let captures = pawn.generateCaptures(at: squareForCheck, board: board)
                            
                            if captures.contains(where: { $0.to == square }) {
                                return true
                            }
                        } else if !(piece is King) {
                            let captures = piece.generateMoves(at: squareForCheck, board: board)
                            
                            if captures.contains(where: { $0.to == square }) {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func isSquareEnemyKingMove(_ square: Square, color: PlayerColor) -> Bool {
        let enemyColor: PlayerColor = color == .black ? .white : .black
        
        let enemyKingSquare = board.findKingPostion(color: enemyColor)
        
        guard let enemyKingSquare = enemyKingSquare else { return false }
        
        guard let enemyKing = board.getPiece(at: enemyKingSquare) else { return false }
        
        let enemyKingMoves = enemyKing.generateMoves(at: enemyKingSquare, board: board)
        
        if enemyKingMoves.contains(where: { $0.to == square }) {
            return true
        }
        
        return false
    }
    
    func moveThreatensKing(move: ChessMove, board: Board, color: PlayerColor) -> Bool {
        var simulatedBoard = board
        var threat = false
        
        if let piece = simulatedBoard.getPiece(at: move.from) {
            simulatedBoard.setPiece(at: move.from, piece: nil)
            simulatedBoard.setPiece(at: move.to, piece: piece)
            
            if isCheck(color: color, board: simulatedBoard) {
                threat = true
            }
        }
        
        return threat
    }
    
    func canCastle(side: CastlingSide, color: PlayerColor, board: Board) -> Bool {
        let row: Int = color == .black ? 0 : 7
        
        let kingSquare = Square(row: row, col: 4)
        let rookSquare = Square(row: row, col: side.rookCol)
        
        //check if there is king
        guard let king = board.getPiece(at: kingSquare) as? King else {
            return false
        }
        
        //check if there is rook
        guard let rook = board.getPiece(at: rookSquare) as? Rook else {
            return false
        }
        
        if rook.hasMoved || king.hasMoved {
            return false
        }
        
        let squaresBetween = board.generateRowPathBetween(start: kingSquare, end: rookSquare)
        
        //check squares between are empty
        for square in squaresBetween {
            if board.getPiece(at: square) != nil {
                return false
            }
        }
        
        if isCheck(color: color, board: board) {
            return false
        }
        
        let direction = side == .kingside ? 1 : -1
        
        // check if end or passing square threatens king
        for num in 1..<3 {
            let move = ChessMove(from: kingSquare, to: Square(row: row, col: kingSquare.col + num * direction))
            
            if moveThreatensKing(move: move, board: board, color: color) {
                return false
            }
        }
        
        return true
    }
}
