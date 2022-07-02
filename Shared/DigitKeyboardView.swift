//
//  DigitKeyboardView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 7/2/22.
//

import SwiftUI


struct DigitKeyboard: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let labels = [
        "7","8","9","÷",
        "4","5","6","×",
        "1","2","3","-",
        "0",".","AC", "+"
    ]
    var onDigit: (String) -> Void
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(labels, id: \.self) { digit in
                DigitButton(label: digit) {
                    onDigit(digit)
                }
            }
        }
        .padding(10)
    }
}


struct DigitButton: View {
    
    var label: String
    
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(label)
                .font(.largeTitle)
                .frame( maxWidth: .infinity)
                .padding(7)
        }
        .buttonStyle(DigitButtonStyle())
            
    }
}

struct DigitButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(.white)
            .background(configuration.isPressed ? .blue : .gray)
            .cornerRadius(30)
            .padding(1)
//            .frame(height: 50)
    }
}
