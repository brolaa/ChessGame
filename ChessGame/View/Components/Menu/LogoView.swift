//
//  LogoView.swift
//  ChessGame
//
//  Created by Bartosz Rola on 30/12/2024.
//

import SwiftUI

struct LogoView: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            Text("Chess")
                .font(.system(size: 50, weight: .bold))
            Text("Game")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color("accentPrimary"))
        }
            .scaleEffect(scale)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    scale = 1.2
                }
            }
        
        
    }
}

#Preview {
    LogoView()
}
