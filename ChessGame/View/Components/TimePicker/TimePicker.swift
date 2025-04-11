//
//  TimePicker.swift
//  ChessGame
//
//  Created by Bartosz Rola on 30/12/2024.
//

import SwiftUI

struct TimePicker: View {
    @Binding var selectedTime: TimeType
    
    var body: some View {
        ZStack {
            PickerBackground(cornerRadius: 20)
            
            HStack {
                ForEach(TimeType.allCases, id: \.self) { time in
                    TimePickerSegment(time: time, isSelected: withAnimation { time == selectedTime} )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedTime = time
                            }
                        }
                        .shadow(radius: time == selectedTime ? 2: 0)
                }
            }
            .frame(width: 300, height: 90)
        }
        .frame(width: 305, height: 95)
    }
}

#Preview {
    TimePicker(selectedTime: .constant(.five))
}
