//
//  PromotionPickerView.swift
//  ChessGame
//
//  Created by Bartosz Rola on 17/12/2024.
//

import SwiftUI

struct PromotionPickerView: View {
    let promotionPieces: [ChessPiece]
    let choosePiece: (Int) -> Void
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.25)
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.gray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.gray, lineWidth: 10)
                            .shadow(radius: 3)
                    )
                HStack {
                    ForEach(promotionPieces.indices, id: \.self) { ind in
                        Button {
                            withAnimation {
                                choosePiece(ind)
                            }
                        } label: {
                            ChessPieceView(piece: promotionPieces[ind])
                        }
                    }
                }
            }
            .frame(width: 300, height: 100)
        }
    }
}


#Preview {
    PromotionPickerView(promotionPieces: [
        Queen(color: .black, wasPromoted: true),
        Rook(color: .black, wasPromoted: true),
        Bishop(color: .black, wasPromoted: true),
        Knight(color: .black, wasPromoted: true)
    ]) {_ in }
}

