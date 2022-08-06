//
//  Library.swift
//  ReCalculator (iOS)
//
//  Created by Kyle Jones on 7/9/22.
//

import Foundation

let subscripts = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇",  "₈",  "₉"]

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
    var variables: [Variable]
}
