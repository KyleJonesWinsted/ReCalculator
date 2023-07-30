//
//  ContentView.swift
//  Shared
//
//  Created by Kyle Jones on 6/25/22.
//

import SwiftUI
import SwiftData

struct FormulaListView: View {

    @Query(sort: \.sortIndex) var formulas: [Formula]
    @State var isNewFormulaViewVisible = false
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(formulas) { formula in
                    NavigationLink(value: formula) {
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
            .navigationDestination(isPresented: $isNewFormulaViewVisible) {
                FormulaCreationView(formula: Formula(text: "", name: "", variables: []))
            }
            .navigationDestination(for: Formula.self) { formula in
                FormulaCreationView(formula: formula)
            }

        }
        .tint(.accentBlue)
    }

    func deleteFormula(indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(formulas[index])
        }
    }

    func moveFormula(indexSet: IndexSet, offset: Int) {
        let descriptor = FetchDescriptor(sortBy: [SortDescriptor(\Formula.sortIndex)])
        guard var formulas: [Formula] = try? modelContext.fetch(descriptor) else {
            return
        }
        formulas.move(fromOffsets: indexSet, toOffset: offset)
        for (index, formula) in formulas.enumerated() {
            formula.sortIndex = index
            modelContext.insert(formula)
        }
    }

    func openNewFormula() {
        isNewFormulaViewVisible = true
    }
}
