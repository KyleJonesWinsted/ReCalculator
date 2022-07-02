//
//  FormulaCreationView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 7/2/22.
//

import SwiftUI

struct FormulaCreationView: View {
    
    @State var formulaText = String()
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                    Text(formulaText)
                        .font(.largeTitle)
                        .flipsForRightToLeftLayoutDirection(true)
                        .environment(\.layoutDirection, .rightToLeft)
            }
            .flipsForRightToLeftLayoutDirection(true)
            .environment(\.layoutDirection, .rightToLeft)
            .padding()
            Spacer()
            DigitKeyboard { input in
                if input == "AC" {
                    $formulaText.wrappedValue.removeAll()
                    return
                }
                $formulaText.wrappedValue.append(input)
            }
        }
    }
}





struct FormulaCreationView_Preview: PreviewProvider {
    static let devices = [
        "iPhone SE",
//        "iPhone 13 mini",
//        "iPhone 13",
//        "iPhone 13 Pro Max"
    ]
    static var previews: some View {
        Group {
            ForEach(devices, id: \.self) { device in
                FormulaCreationView()
                    .previewDevice(PreviewDevice(rawValue: device))
                    .previewDisplayName(device)
            }
        }
    }
}
