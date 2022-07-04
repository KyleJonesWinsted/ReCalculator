//
//  FormulaCreationView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 7/2/22.
//

import SwiftUI
import MathParser

struct Variable: Identifiable {
    var id = UUID()
    var name: String
    var symbol: String
    var isSelected = false
}

struct FormulaCreationView: View {
    
    @State var formulaText = String()
    @State var variables = [Variable]()
    @State var variableValues = [String]()
    @State var isAddingVariable = false
    @FocusState var isVariableFieldFocused: Bool
    @State var newVariableName = ""
    var selectedVariableIndex: Int? { variables.firstIndex { $0.isSelected} }
    
    var body: some View {
        if isAddingVariable {
            TextField("New Variable Name", text: $newVariableName)
                .onSubmit {
                    addNewVariable(name: newVariableName)
                    isAddingVariable = false
                    newVariableName = ""
                }
                .disableAutocorrection(true)
                .font(.title)
                .submitLabel(.done)
                .focused($isVariableFieldFocused)
                .padding()
        } else {
            VStack {
                FormulaTextView(text: formulaText, isSelected: variables.filter { $0.isSelected }.count < 1)
                    .onTapGesture {
                        clearVariableSelection()
                    }
                HStack {
                    Text("Answer")
                    Spacer()
                    Text(answer ?? "--").font(.largeTitle)
                }
                .padding()
                VariableListView(input: $formulaText, variables: $variables, variableValues: variableValues)
                Spacer()
                DigitKeyboard(input: selectedVariableIndex != nil ? $variableValues[selectedVariableIndex!] : $formulaText) {
                    self.isAddingVariable = true
                    self.isVariableFieldFocused = true
                }
            }
        }
    }
    
    func clearVariableSelection() {
        for i in variables.indices {
            variables[i].isSelected = false
        }
    }
    
    var answer: String? {
        var expression = formulaText
        for i in variables.indices {
            expression = expression.replacingOccurrences(of: variables[i].symbol, with: variableValues[i])
        }
        guard let answer = try? expression.evaluate() else { return nil }
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        return formatter.string(from: NSNumber(value: answer))
    }
    
    func addNewVariable(name: String) {
        let subscripts = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇",  "₈",  "₉"]
        guard let symbol = name.first else { return }
        let subIndex = variables
            .filter { $0.name.starts(with: String(symbol)) }
            .count
        variables.append(Variable(name: name, symbol: "\(symbol)\(subscripts[subIndex % subscripts.count])" ))
        variableValues.append("")
    }
}

struct VariableListView: View {
    @Binding var input: String
    @Binding var variables: [Variable]
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
                Text(variable.name)
                let hasValue = value.count > 0
                Text(hasValue ? value : "--")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .contentShape(Rectangle())
                    .font(.largeTitle)
                    .foregroundColor(hasValue ? .primary : .gray)
            }
            .onTapGesture {
                for i in variables.indices {
                    variables[i].isSelected = variables[i].id == variable.id
                }
            }
            .listRowBackground(variable.isSelected ? Color.blue : Color.init(white: 100, opacity: 0.0))
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
                .foregroundColor(hasValue ? .primary : .gray)
                .flipsForRightToLeftLayoutDirection(true)
                .environment(\.layoutDirection, .rightToLeft)
                .padding()
        }
        .flipsForRightToLeftLayoutDirection(true)
        .environment(\.layoutDirection, .rightToLeft)
        .background(isSelected ? Color.blue : Color.init(white: 100, opacity: 0))
    }
}
