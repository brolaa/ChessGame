//
//  GameViewModel.swift
//  ChessGame
//
//  Created by Bartosz Rola on 26/11/2024.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published private(set) var gameModel: GameModel
    
    @Published private(set) var selectedSquare: Square? = nil
    @Published private(set) var promotionPawn: ChessMove? = nil
    @Published private(set) var piecePossibleMoves = [ChessMove]()
    
    @Published var showingPromotionPicker = false
    @Published var showingEndAlert = false
    @Published var showingSurrenderConfirmation = false
    @Published private(set) var alertTitle = ""
    @Published private(set) var alertMessage = ""
    
    init(time: Int) {
        gameModel = GameModel(time: time)
    }
    
    var rotated: Bool {
        return gameModel.board.rotated
    }
    
    var playerColor: PlayerColor {
        return gameModel.playerColor
    }
    
    var whiteScore: Int {
        return gameModel.whiteScore
    }
    
    var blackScore: Int {
        return gameModel.blackScore
    }
    
    var whiteCapturedPieces: [String] {
        return gameModel.whiteCapturedPieces
    }
    
    var blackCapturedPieces: [String] {
        return gameModel.blackCapturedPieces
    }
    
    var gameHasTime: Bool {
        return gameModel.gameHasTime
    }
    
    var whiteTime: Int {
        return gameModel.chessTimer.whiteTime
    }
    
    var blackTime: Int {
        return gameModel.chessTimer.blackTime
    }
    
    var promotionPieces: [ChessPiece] {
        return gameModel.promotionPieces
    }
    
    var chessTimer: ChessTimer {
        return gameModel.chessTimer
    }
    
    func rotateChessboard() {
        gameModel.board.rotateChessboard()
    }
    
    func surrenderButtonAction() {
        showingSurrenderConfirmation = true
    }
    
    func updateTimer() {
        if gameModel.chessTimer.timerRunning {
            gameModel.chessTimer.update()
            
            if gameModel.chessTimer.whiteTime == 0 {
                endGame(winningColor: .black)
            } else if gameModel.chessTimer.blackTime == 0 {
                endGame(winningColor: .white)
            }
        }
    }

    func surrenderGame() {
        endGame(winningColor: gameModel.opponentColor)
    }
    
    func endGame(winningColor: PlayerColor?) {
        if let winningColor = winningColor {
            var winnerScore: Int
            
            if winningColor == .white {
                winnerScore = whiteScore
            } else {
                winnerScore = blackScore
            }
            
            alertTitle = "Player \(winningColor) won!"
            alertMessage = "Winner score: \(winnerScore)"
        } else {
            alertTitle = "Stalemate!"
            alertMessage = "Nobody wins."
        }
        
        
        showingEndAlert = true
        
        if gameModel.gameHasTime {
            gameModel.chessTimer.stop()
            gameModel.chessTimer.turnOff()
        }
    }
    
    func endTurn(move: ChessMove, promotion: Bool) {
        selectedSquare = nil
        piecePossibleMoves = []
        
        
        if gameModel.isCheckmate(color: gameModel.opponentColor, board: gameModel.board) {
            endGame(winningColor: gameModel.playerColor)
        }
        
        if gameModel.isStalemate(color: gameModel.opponentColor, board: gameModel.board) || gameModel.board.halfMoveClock >= 100 {
            endGame(winningColor: nil)
        }
        
        if gameModel.playerColor == .white {
            gameModel.changePlayerColor(.black)
        } else {
            gameModel.changePlayerColor(.white)
        }
        
        if gameModel.gameHasTime {
            gameModel.chessTimer.changeUpdatedColor(color: gameModel.playerColor)
        }
    }
    
    func handleSquareInteraction(at square: Square) {
        if let move = piecePossibleMoves.first(where: {
            $0.to == square
        }) {
            makeMove(move)
        } else {
            selectedSquare = square
            piecePossibleMoves = gameModel.generateLegalMoves(for: selectedSquare)
        }
    }
    
    func makeMove(_ move: ChessMove) {
        guard let piece = gameModel.board.getPiece(at: move.from) else { return }
                
        // pawn promotion
        if piece is Pawn {
            if move.to.row == 0 || move.to.row == 7 {
                promotionPawn = move
                showingPromotionPicker = true
                return
            }
        }
        
        gameModel.movePiece(move)
        
        
        endTurn(move: move, promotion: false)
    }
    
    func makeMovePromotion(move: ChessMove, to piece: ChessPiece) {
        gameModel.promotePawn(move: move, to: piece)
        
        endTurn(move: move, promotion: true)
    }
     
    
    func choosePromotionPiece(_ ind: Int) {
        if let promotionPawn = promotionPawn {
            makeMovePromotion(move: promotionPawn, to: gameModel.promotionPieces[ind])
        }
        showingPromotionPicker = false
    }

    func getPiece(at square: Square) -> ChessPiece? {
        return gameModel.board.getPiece(at: square)
    }
}
