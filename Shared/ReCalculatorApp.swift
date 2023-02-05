//
//  ReCalculatorApp.swift
//  Shared
//
//  Created by Kyle Jones on 6/25/22.
//

import SwiftUI

/// TODO:
/// Add formula names, enter name when saving new formula
/// Use proper modal view for adding variables using sheets

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
