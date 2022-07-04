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
    var value: String = "1"
    var isSelected = false
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
                HStack {
                    Text("Answer")
                    Spacer()
                    Text(answer ?? "--").font(.largeTitle)
                }
                .padding()
                VariableListView(input: $formulaText, variables: variables)
                Spacer()
                DigitKeyboard(input: $formulaText) {
                    self.isAddingVariable = true
                    self.isVariableFieldFocused = true
                }
            }
        }
    }
    
    var answer: String? {
        var expression = formulaText
        for variable in variables {
            expression = expression.replacingOccurrences(of: variable.symbol, with: variable.value)
        }
        guard let answer = try? expression.evaluate() else { return nil }
        let formatter = NumberFormatter()
        formatter.maximumSignificantDigits = 12
        return formatter.string(from: NSNumber(value: answer))
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
                let hasValue = variable.value.count > 0
                Text(hasValue ? variable.value : "--")
                    .font(.largeTitle)
                    .foregroundColor(hasValue ? .primary : .gray)
            }
            .listRowBackground(variable.isSelected ? Color.blue : Color.init(white: 100, opacity: 0.0))
        }
        .listStyle(.plain)
    }
}

struct FormulaTextView: View {
    var text: String
    var body: some View {
        ScrollView(.horizontal) {
            let hasValue = text.count > 0
            Text(hasValue ? text : "Enter Formula")
                .font(.largeTitle)
                .foregroundColor(hasValue ? .primary : .gray)
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
