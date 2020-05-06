//
//  ContentView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 5/5/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var testText: String = ""
    
    var body: some View {
        MathEntryTextField(title: "Enter Formula")
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class MathEntryTextField: UIViewRepresentable {
    
    typealias UIViewType = UITextField

    var placeholderText: String?
    let accessoryView = MathEntryInputAccessory(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
    
    init(title: String) {
        self.placeholderText = title
    }
    
    init() {
        self.placeholderText = nil
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.placeholder = self.placeholderText ?? ""
        accessoryView.textField = textField
        textField.inputAccessoryView = self.accessoryView
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        return
    }
    
}

class MathEntryInputAccessory: UIView {
    
    var textField: UITextField?
    
    let testButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("√", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(testSelector), for: .touchUpInside)
        button.sizeThatFits(CGSize(width: 1000, height: 50))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupMathEntryInputAccessory()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMathEntryInputAccessory() {
        self.backgroundColor = .systemGray5
        self.addSubview(testButton)
    }
    
    @objc func testSelector() {
        guard let textField = self.textField,
            let selectedRange = textField.selectedTextRange else { return }
        textField.replace(selectedRange, withText: "√()")
        if let newPosition = textField.position(from: selectedRange.start, offset: 2) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
}
