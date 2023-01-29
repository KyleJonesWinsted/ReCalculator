//
//  ReCalculatorApp.swift
//  Shared
//
//  Created by Kyle Jones on 6/25/22.
//

import SwiftUI

/// TODO:
/// Make Save button only appear when text changed
/// Dismiss formula creation view when clicking save
/// Update app colors
/// Use proper modal view  for adding variables using sheets

@main
struct ReCalculatorApp: App {

  @StateObject var formulaController = FormulaController()

  var body: some Scene {
    WindowGroup {
      FormulaListView(formulas: $formulaController.formulas)
        .onAppear {
          FormulaController.load { result in
            switch result {
            case .success(let formulas):
              formulaController.formulas = formulas
            case .failure(let error):
              fatalError(error.localizedDescription)
            }
          }
        }
        .environmentObject(formulaController)
    }
  }
}
