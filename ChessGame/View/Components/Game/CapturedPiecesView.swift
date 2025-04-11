//
//  CapturedPiecesView.swift
//  ChessGame
//
//  Created by Bartosz Rola on 03/12/2024.
//

import SwiftUI

struct CapturedPiecesView: View {
    let pieces: [String]
    let color: PlayerColor
    
    var filteredPieces: [[String]] {
        return filterPieces()
    }
    
    let pieceTypes = ["queen", "rook", "bishop", "knight", "pawn"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(filteredPieces.indices, id: \.self) { type in
                HStack {
                    ZStack {
                        ForEach(filteredPieces[type].indices , id: \.self) { num in
                            Image(pieceImage(for: filteredPieces[type][num]))
                                .resizable()
                                .frame(width: 20, height: 20)
                                .offset(x: CGFloat(num) * 5)
                        }
                    }
                }
            }
        }
    }
                
    func pieceImage(for piece: String) -> String {
        return piece + "_" + (color == .black ? "b" : "w")
    }
    
    func filterPieces() -> [[String]] {
        var filteredPieces = [[String]]()
        
        pieceTypes.forEach { piceType in
            let pieces = pieces.filter { $0 == piceType }
            filteredPieces.append(pieces)
        }
        
        return filteredPieces
    }
}


#Preview {
    CapturedPiecesView(pieces: ["pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "knight", "knight", "queen", "bishop", "bishop", "rook", "rook"], color: .white)
}
