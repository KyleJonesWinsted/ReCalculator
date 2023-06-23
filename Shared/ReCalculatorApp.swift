//
//  ReCalculatorApp.swift
//  Shared
//
//  Created by Kyle Jones on 6/25/22.
//

import SwiftUI

@main
struct ReCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            FormulaListView()
                .modelContainer(for: Formula.self)
        }
    }
}
