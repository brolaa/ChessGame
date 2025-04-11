//
//  ChessboardView.swift
//  ChessGame
//
//  Created by Bartosz Rola on 26/11/2024.
//

import SwiftUI

struct ChessboardView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<8) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<8) { col in
                            ChessboardSquareView(
                                viewModel: viewModel,
                                square: Square(row: row, col: col))
                            
                            .onTapGesture {
                                withAnimation {
                                    viewModel.handleSquareInteraction(at: Square(row: row, col: col))
                                }
                            }
                        }
                    }
                }
            }
        }
        .rotationEffect(viewModel.rotated ? .degrees(180) : .degrees(0))
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global).onEnded { value in
            let horizontalAmount = value.translation.width
            let verticalAmount = value.translation.height
            
            if abs(horizontalAmount) > abs(verticalAmount) {
                withAnimation(.spring(duration: 0.5, bounce: 0.1, blendDuration: 0.2))  {
                    viewModel.rotateChessboard()
                }
            }
        })
    }
}

/*
 #Preview {
    ChessboardView()
 }
 */
