//
//  MenuView.swift
//  ChessGame
//
//  Created by Bartosz Rola on 30/12/2024.
//

import SwiftUI

struct MenuView: View {
    @State var time: TimeType = .ten
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    LogoView()
                    
                    Spacer()
                    
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Choose time for game")
                                .font(.headline)
                            TimePicker(selectedTime: $time)
                        }
                        .padding()

                        NavigationLink {
                            GameView(time: time.rawValue)
                        } label: {
                            PrimaryButton(text: "Start Game")
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MenuView()
}
