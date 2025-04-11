//
//  GameView.swift
//  ChessGame
//
//  Created by Bartosz Rola on 30/12/2024.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                PlayerBarView(viewModel: viewModel, color: .black)
                
                ChessboardView(viewModel: viewModel)
                    .zIndex(1)
                
                PlayerBarView(viewModel: viewModel, color: .white)
                
                Spacer()
                
                HStack {
                    GameButton("Surrender", icon: "flag.2.crossed") {
                        viewModel.surrenderButtonAction()
                    }
                    
                    Spacer()
                    
                    GameButton("Rotate", icon: "arrow.trianglehead.2.counterclockwise.rotate.90") {
                        withAnimation(.spring(duration: 0.5, bounce: 0.1, blendDuration: 0.2)) {
                            viewModel.rotateChessboard()
                        }
                    }
                }
            }
            
            if (viewModel.showingPromotionPicker) {
                PromotionPickerView(promotionPieces: viewModel.promotionPieces, choosePiece: viewModel.choosePromotionPiece)
                    .transition(.opacity)
            }
        }
        .onReceive(viewModel.chessTimer.timer) { _ in
            viewModel.updateTimer()
        }
        .confirmationDialog("Are you sure?", isPresented: $viewModel.showingSurrenderConfirmation, titleVisibility: .visible) {
            Button("Yes", role: .destructive) {
                viewModel.surrenderGame()
            }
            Button("No", role: .cancel) {}
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showingEndAlert, actions: {
            Button("OK") {
                dismiss()
            }
        }, message: {
            Text(viewModel.alertMessage)
        })
        .navigationBarBackButtonHidden(true)
        
    }
    
    init(time: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(time: time))
    }
}

#Preview {
    GameView(time: 10)
}
