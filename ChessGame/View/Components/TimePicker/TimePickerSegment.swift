//
//  TimePickerSegment.swift
//  ChessGame
//
//  Created by Bartosz Rola on 30/12/2024.
//

import SwiftUI

struct TimePickerSegment: View {
    let time: TimeType
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: time.info.icon)
                .font(.largeTitle)
                .padding(1)
            
            Text(time.info.name)
                .font(.caption)
                .fontWeight(.bold)
        }
        .foregroundColor(isSelected ? .white : Color("secondaryText"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isSelected ? Color("accentSelected") : nil)
        .cornerRadius(20)
    }
}

#Preview {
    TimePickerSegment(time: .five, isSelected: true)
}
