//
//  PickerBackground.swift
//  ChessGame
//
//  Created by Bartosz Rola on 30/12/2024.
//

import SwiftUI

struct PickerBackground: View {
    let cornerRadius: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(Color("accentLight"))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color("accentDark"), lineWidth: 5)
                .shadow(radius: 2))
    }
}

#Preview {
    PickerBackground(cornerRadius: 20)
}
