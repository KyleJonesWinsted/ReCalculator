//
//  FormulaCreationView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 7/2/22.
//

import SwiftUI

struct Variable: Identifiable {
    var id = UUID()
    var name: String
    var symbol: String
    var value: String = ""
}

struct FormulaCreationView: View {
    
    @State var formulaText = String()
    @State var variables = [Variable]()
    @State var isAddingVariable = false
    @FocusState var isVariableFieldFocused: Bool
    @State var newVariableName = ""
    
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
                FormulaTextView(text: formulaText)
                VariableListView(input: $formulaText, variables: variables)
                Spacer()
                DigitKeyboard(input: $formulaText) {
                    self.isAddingVariable = true
                    self.isVariableFieldFocused = true
                }
            }
        }
    }
    
    func addNewVariable(name: String) {
        let subscripts = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇",  "₈",  "₉"]
        guard let symbol = name.first else { return }
        let subIndex = variables
            .filter { $0.name.starts(with: String(symbol)) }
            .count
        variables.append(Variable(name: name, symbol: "\(symbol)\(subscripts[subIndex % subscripts.count])" ))
    }
}

struct VariableListView: View {
    @Binding var input: String
    var variables: [Variable]
    var body: some View {
        List(variables) { variable in
            HStack {
                DigitButton(label: variable.symbol) {
                    input.append(variable.symbol)
                }
                .frame(width: 80)
                Text(variable.name)
                Spacer()
                Text(variable.value)
            }
        }
        .listStyle(.plain)
    }
}

struct FormulaTextView: View {
    var text: String
    var body: some View {
        ScrollView(.horizontal) {
            Text(text.count < 1 ? " " : text)
                .font(.largeTitle)
                .flipsForRightToLeftLayoutDirection(true)
                .environment(\.layoutDirection, .rightToLeft)
        }
        .flipsForRightToLeftLayoutDirection(true)
        .environment(\.layoutDirection, .rightToLeft)
        .padding()
    }
}

struct FormulaCreationView_Preview: PreviewProvider {
    static let devices = [
        "iPhone SE",
//        "iPhone 13 mini",
//        "iPhone 13",
//        "iPhone 13 Pro Max"
    ]
    static var previews: some View {
        Group {
            ForEach(devices, id: \.self) { device in
                FormulaCreationView(formulaText: "2+2",variables: [
                    Variable(name: "Hello", symbol: "H", value: "42"),
                    Variable(name: "World", symbol: "W", value: "2")
                ])
                    .previewDevice(PreviewDevice(rawValue: device))
                    .previewDisplayName(device)
            }
        }
    }
}
