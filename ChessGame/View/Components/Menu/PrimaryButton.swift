//
//  PrimaryButton.swift
//  ChessGame
//
//  Created by Bartosz Rola on 30/12/2024.
//

import SwiftUI

struct PrimaryButton: View {
    let text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("accentPrimary"))
                .frame(width: 140, height: 60)
            
            Text(text)
                .font(.title3)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    PrimaryButton(text: "Button")
}
