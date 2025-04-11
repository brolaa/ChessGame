//
//  ChessPieceView.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import SwiftUI

struct ChessPieceView: View {
    var piece: ChessPiece
    
    var image: String {
        return piece.name + "_" + (piece.color == .black ? "b" : "w")
    }
        
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
    }
}

#Preview {
    ChessPieceView(piece: Pawn(color: .black))
}
