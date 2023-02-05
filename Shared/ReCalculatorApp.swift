//
//  ReCalculatorApp.swift
//  Shared
//
//  Created by Kyle Jones on 6/25/22.
//

import SwiftUI

/// TODO:
/// Add default formulas
/// Add app icon
/// Add store info (description, images, privacy policy, etc.)

@main
struct ReCalculatorApp: App {

    @StateObject var formulaController = FormulaController()
    @State var alertPresented = false

    var body: some Scene {
        WindowGroup {
            FormulaListView(formulas: $formulaController.formulas)
                .onAppear {
                    FormulaController.load { result in
                        switch result {
                        case .success(let formulas):
                            formulaController.formulas = formulas
                        case .failure(let error):
                            print(error)
                            alertPresented = true
                        }
                    }
                }
                .alert(
                    "Error Loading Formulas", isPresented: $alertPresented,
                    actions: {}
                )
                .environmentObject(formulaController)
        }
    }
}
