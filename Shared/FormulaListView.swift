//
//  ContentView.swift
//  Shared
//
//  Created by Kyle Jones on 6/25/22.
//

import SwiftUI

struct FormulaListView: View {
    
    @Binding var formulas: [Formula]
    @State var isNewFormulaViewVisible = false
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $isNewFormulaViewVisible) {
                    FormulaCreationView(formula: Formula(text: "", variables: [])).navigationBarTitleDisplayMode(.inline)
                } label: { EmptyView() }
                
                List(formulas) { formula in
                    NavigationLink {
                        FormulaCreationView(formula: formula).navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Text(formula.text)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: openNewFormula) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationTitle("Formulas")
            }
            
        }
        .tint(.accentBlue)
    }
    
    func openNewFormula() {
        isNewFormulaViewVisible = true
    }
}
