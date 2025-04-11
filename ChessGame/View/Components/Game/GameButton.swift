//
//  GameButton.swift
//  ChessGame
//
//  Created by Bartosz Rola on 31/12/2024.
//

import SwiftUI

struct GameButton: View {
    let text: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Image(systemName: icon)
                    .font(.title)
                Text(text)
                    .font(.caption)
            }
            .padding()
            .foregroundStyle(.white)
        }
    }
    
    init(_ text: String, icon: String, action: @escaping () -> Void) {
        self.text = text
        self.icon = icon
        self.action = action
    }
}

#Preview {
    GameButton("Action", icon: "checkmark.circle") {
        
    }
}
