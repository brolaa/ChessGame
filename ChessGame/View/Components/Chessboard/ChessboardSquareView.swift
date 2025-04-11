//
//  ChessboardSquareView.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import SwiftUI

struct ChessboardSquareView: View {
    @ObservedObject var viewModel: GameViewModel
    
    let square: Square
    let rowLabel = ["a","b","c","d","e","f","g","h"]
    
    var isSelected: Bool {
        return (viewModel.selectedSquare ?? Square(row: -1,col: -1)) == square
    }
    
    var piece: ChessPiece? {
        return viewModel.getPiece(at: square)
    }
            
    var body: some View {
        ZStack() {
            Rectangle()
                .fill((square.row + square.col).isMultiple(of: 2) ? Color("light") : Color("dark"))
                .overlay(
                    viewModel.piecePossibleMoves.contains { $0.to == square } ?
                    Circle()
                        .fill(Color.black)
                        .padding(piece != nil ? 5 : 15)
                        .opacity(0.5) : nil
                )
                .transaction { transaction in
                    transaction.animation = nil
                }
                
            
            if let piece = piece {
                if piece.color == viewModel.playerColor && isSelected {
                    Rectangle()
                        .fill(Color("selected"))
                }
            }
             
        
            if let piece = piece {
                ChessPieceView(piece: piece)
                    .rotationEffect(viewModel.rotated ? .degrees(180) : .degrees(0))
            }
        }
        .overlay(alignment: .topTrailing, content: {
            Group {
                if (square.col == 7 && !viewModel.rotated) {
                    Text("\(8 - square.row)")
                        
                } else if (square.row == 0 && viewModel.rotated) {
                    Text("\(rowLabel[square.col])")
                        .rotationEffect(.degrees(180))
                }
                
            }
            .foregroundColor((square.row + square.col).isMultiple(of: 2) ? Color("dark") : Color("light"))
            .font(.footnote)
            
            
        })
        .overlay(alignment: .bottomLeading, content: {
            Group {
                if (square.row == 7 && !viewModel.rotated) {
                    Text(rowLabel[square.col])
                        
                } else if (square.col == 0 && viewModel.rotated) {
                    Text("\(8 - square.row)")
                        .rotationEffect(.degrees(180))
                }
            }
            .foregroundColor((square.row + square.col).isMultiple(of: 2) ? Color("dark") : Color("light"))
            .font(.footnote)
            
        })
        .aspectRatio(1, contentMode: .fit)
    }
}

/*
 #Preview {
 ChessboardSquareView(square: Square(row: 7, col: 7), isSelected: true, playerColor: .white, legalMoves: [ChessMove]())
 }
 */
