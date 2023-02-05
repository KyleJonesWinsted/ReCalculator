//
//  Library.swift
//  ReCalculator (iOS)
//
//  Created by Kyle Jones on 7/9/22.
//

import Foundation
import SwiftUI

let subscripts = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]

extension Array {
    subscript(safe index: Int) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}

struct Variable: Identifiable, Codable {
    var id = UUID()
    var name: String
    var symbol: String
    var isSelected = false
}

struct Formula: Identifiable, Codable {
    var id = UUID()
    var text: String
    var name: String
    var variables: [Variable]
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }

    static let buttonOperator = Color(hex: 0xFA7921)
    static let buttonAccent = Color(hex: 0x09BC8A)
    static let buttonGray = Color(hex: 0x393E41)
    static let selection = Color(hex: 0xE6E1DB)
    static let accentBlue = Color(hex: 0x629FD0)
}

extension EnvironmentValues {
    var isZoomed: Bool {
        UIScreen.main.nativeScale != UIScreen.main.scale
    }
}
