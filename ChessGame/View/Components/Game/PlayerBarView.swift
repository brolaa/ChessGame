//
//  PlayerBarView.swift
//  ChessGame
//
//  Created by student on 17/12/2024.
//

import SwiftUI

struct PlayerBarView: View {
    @ObservedObject var viewModel: GameViewModel
    let color: PlayerColor
    
    var body: some View {
        ZStack {
            Color("accentLight")
                .shadow(radius: 3)
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Text("Player \(color.rawValue)")
                            .font(.headline)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(Color("accentDark"))
                            Text("Score: \(score)")
                                .font(.subheadline)
                                .animation(nil)
                        }
                        .frame(width: 80, height: 20)
                    }
                    
                    Spacer()
                    
                    CapturedPiecesView(pieces: capturedPieces, color: opponentColor)
                    
                }
                .padding(10)
                
                Spacer()
                
                if let time = time {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.shadow(.inner(radius: 2, x: 2, y: 2)))
                            .foregroundStyle(turn ? Color("accentPrimary") : Color("accentDark"))
                        
                        Text(time)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(width: 100, height: 50)
                    .padding(.horizontal, 7)
                } else {
                    Circle()
                        .fill(.shadow(.inner(radius: 2, x: 2, y: 2)))
                        .foregroundColor(turn ? Color("accentPrimary") : Color("accentDark"))
                        .frame(width: 20)
                        .padding(.horizontal)
                }
                
            }
        }
        .frame(height: 70)
    }
    
    var time: String? {
        if viewModel.gameHasTime {
            var time: Int
            
            if color == .white {
                time = viewModel.whiteTime
            } else {
                time = viewModel.blackTime
            }
            
            let minutes: Int = time / 60
            let seconds: Int = time % 60
            let zeroSec = seconds < 10 ? "0" : ""
            
            return "\(minutes):\(zeroSec)\(seconds)"
        }
        
        return nil
    }
    
    var turn: Bool {
        if viewModel.playerColor == color {
            return true
        } else {
            return false
        }
    }
    
    var capturedPieces: [String] {
        if color == .white {
            return viewModel.whiteCapturedPieces
        } else {
            return viewModel.blackCapturedPieces
        }
    }
    
    var score: Int {
        if color == .white {
            return viewModel.whiteScore
        } else {
            return viewModel.blackScore
        }
    }
    
    var opponentColor: PlayerColor {
        if color == .white {
            return .black
        } else {
            return .white
        }
    }
}

/*
#Preview {
    PlayerBarView(playerColor: .black, playerScore: 15, capturedPieces: ["pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "knight", "knight", "queen", "bishop", "bishop", "rook", "rook"])
}
*/
