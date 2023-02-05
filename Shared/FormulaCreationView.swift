//
//  FormulaCreationView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 7/2/22.
//

import MathParser
import SwiftUI

struct FormulaCreationView: View {

    @EnvironmentObject var formulaController: FormulaController

    @State var formula: Formula
    @State var variableValues: [String]
    @State var isAddingVariable = false
    @State var isSavingFormula = false
    @FocusState var isVariableFieldFocused: Bool
    @FocusState var isFormulaNameFocused: Bool
    @State var newVariableName = ""
    @State var textDidChange = false
    var selectedVariableIndex: Int? { formula.variables.firstIndex { $0.isSelected } }

    init(formula: Formula) {
        _formula = State(initialValue: formula)
        _variableValues = State(initialValue: Array(repeating: "", count: formula.variables.count))
    }

    var body: some View {

        if isAddingVariable {
            SingleInputForm(
                title: "Variable Name",
                placeholder: "New Variable Name",
                text: $newVariableName,
                isFocused: _isVariableFieldFocused
            ) {
                withAnimation {
                    addNewVariable(name: newVariableName)
                    isAddingVariable = false
                    newVariableName = ""
                }
            }
        } else if isSavingFormula {
            SingleInputForm(
                title: "Formula Name",
                placeholder: "New Formula Name",
                text: $formula.name, isFocused: _isFormulaNameFocused
            ) {
                isSavingFormula = false
                saveFormula()
            }
        } else {
            VStack {
                Text("")
                FormulaTextView(
                    text: formula.text,
                    isSelected: formula.variables.filter { $0.isSelected }.count < 1
                )
                .onTapGesture {
                    clearVariableSelection()
                }
                HStack {
                    Text("Result")
                    Spacer()
                    Text(answer ?? "--")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                .padding([.leading, .trailing])
                VariableListView(
                    input: $formula.text, variables: $formula.variables,
                    selectedIndex: selectedVariableIndex,
                    variableValues: variableValues
                )
                .overlay(Divider(), alignment: .bottom)
                .overlay(Divider(), alignment: .top)
                Spacer()
                DigitKeyboard(
                    input: selectedVariableIndex != nil
                        ? $variableValues[selectedVariableIndex!] : $formula.text,
                    addVariable: {
                        withAnimation {
                            self.isAddingVariable = true
                            self.isVariableFieldFocused = true
                        }
                    })

            }
            .onChange(of: formula.text, perform: { _ in textDidChange = true })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if textDidChange {
                        Button("Save", action: openSaveDialog).foregroundColor(
                            .accentBlue)
                    }
                }
            }
            .navigationTitle(formula.name)

        }
    }

    func openSaveDialog() {
        withAnimation {
            isSavingFormula = true
            isFormulaNameFocused = true
        }
    }

    func saveFormula() {
        textDidChange = false
        selectVariable(index: 0)
        formula.name = formula.name.trimmingCharacters(in: .whitespacesAndNewlines)
        formula.text = formula.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let index = formulaController.formulas.firstIndex(where: { $0.id == formula.id }) {
            formulaController.formulas[index] = formula
        } else {
            formulaController.formulas.insert(formula, at: 0)
        }
    }

    func selectVariable(index: Int) {
        clearVariableSelection()
        if formula.variables.count > index {
            formula.variables[index].isSelected = true
        }
    }

    func clearVariableSelection() {
        for i in formula.variables.indices {
            formula.variables[i].isSelected = false
        }
    }

    var answer: String? {
        var expression = formula.text
        for i in formula.variables.indices {
            expression = expression.replacingOccurrences(
                of: formula.variables[i].symbol, with: variableValues[i])
        }
        guard let answer = try? expression.evaluate() else { return nil }
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: answer))
    }

    func addNewVariable(name: String) {
        guard let symbol = name.first else { return }
        let subIndex = formula.variables
            .filter { $0.name.starts(with: String(symbol)) }
            .count
        formula.variables.insert(
            Variable(name: name, symbol: "\(symbol)\(subscripts[subIndex % subscripts.count])"),
            at: 0)
        variableValues.insert("", at: 0)
        clearVariableSelection()
    }

}

struct SingleInputForm: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    @FocusState var isFocused: Bool
    var onSubmit: () -> Void

    var body: some View {
        Form {
            Section(title) {
                TextField(placeholder, text: $text)
                    .onSubmit(onSubmit)
                    .disableAutocorrection(true)
                    .font(.title)
                    .submitLabel(.done)
                    .focused($isFocused)
                    .padding([.top, .bottom], 10)
            }
        }
        .transition(.move(edge: .bottom))
    }
}

struct VariableListView: View {
    @Binding var input: String
    @Binding var variables: [Variable]
    var selectedIndex: Int?
    var variableValues: [String]
    var body: some View {
        List(variables.indices, id: \.self) { i in
            let variable = variables[i]
            let value = variableValues[i]
            HStack {
                DigitButton(label: variable.symbol) {
                    input.append(variable.symbol)
                }
                .frame(width: 80)
                Text(variable.name).foregroundColor(variable.isSelected ? .black : .primary)
                let hasValue = value.count > 0
                Text(hasValue ? value : "--")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .contentShape(Rectangle())
                    .font(.largeTitle)
                    .foregroundColor(hasValue ? variable.isSelected ? .black : .primary : .gray)
            }
            .onTapGesture {
                for i in variables.indices {
                    variables[i].isSelected = variables[i].id == variable.id
                }
            }
            .listRowBackground(
                variable.isSelected ? Color.selection : Color.init(white: 100, opacity: 0.0))
        }
        .listStyle(.plain)
    }
}

struct FormulaTextView: View {
    var text: String
    var isSelected: Bool
    var body: some View {
        ScrollView(.horizontal) {
            let hasValue = text.count > 0
            Text(hasValue ? text : "Enter Formula")
                .font(.largeTitle)
                .foregroundColor(hasValue ? isSelected ? .black : .primary : .gray)
                .flipsForRightToLeftLayoutDirection(true)
                .environment(\.layoutDirection, .rightToLeft)
                .padding()
        }
        .flipsForRightToLeftLayoutDirection(true)
        .environment(\.layoutDirection, .rightToLeft)
        .background(isSelected ? Color.selection : Color.init(white: 100, opacity: 0))
    }
}
