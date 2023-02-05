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
    @EnvironmentObject var formulaController: FormulaController

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $isNewFormulaViewVisible) {
                    FormulaCreationView(formula: Formula(text: "", name: "", variables: []))
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    EmptyView()
                }

                List {
                    ForEach(formulas) { formula in
                        NavigationLink {
                            FormulaCreationView(formula: formula)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            VStack {
                                Text(formula.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(formula.text)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .onDelete(perform: deleteFormula)
                    .onMove(perform: moveFormula)
                }
                .toolbar {
                    EditButton()
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

    func deleteFormula(indexSet: IndexSet) {
        formulaController.formulas.remove(atOffsets: indexSet)
    }

    func moveFormula(indexSet: IndexSet, offset: Int) {
        formulaController.formulas.move(fromOffsets: indexSet, toOffset: offset)
    }

    func openNewFormula() {
        isNewFormulaViewVisible = true
    }
}
