//
//  CreateEditFormulaView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 5/12/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import UIKit

enum InputAccessoryButtonLabels: String, CaseIterable {
    case sqrt = "√"
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    case openParan = "("
    case closeParan = ")"
}

class CreateEditFormulaView: UIView {
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Formula"
        textField.keyboardType = .decimalPad
        textField.font = .boldSystemFont(ofSize: 20.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let accessory: UIView = {
        let accessory = UIView()
        accessory.backgroundColor = .systemGray5
        accessory.frame = CGRect(x: 0, y: 0, width: 0, height: 40.0)
        accessory.translatesAutoresizingMaskIntoConstraints = false
        return accessory
    }()
    
    let accessoryButtons: [UIButton] = {
        var buttons = [UIButton]()
        for label in InputAccessoryButtonLabels.allCases {
            let button = UIButton()
            button.setTitle(label.rawValue, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.white, for: .highlighted)
            button.addTarget(self, action: #selector(insertFromAccessory), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            buttons.append(button)
        }
        return buttons
    }()
    
    let variableButtons: [UIButton] = {
        var buttons = [UIButton]()
        for i in 1...3 {
            let button = UIButton()
            button.setTitle(i.description, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.setTitleColor(.gray, for: .highlighted)
            button.addTarget(self, action: #selector(insertVariable), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            buttons.append(button)
        }
        return buttons
    }()
    
    let variableStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let accessoryStackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        textField.inputAccessoryView = accessory
            
        //Set child views
        addSubview(textField)
        addSubview(variableStack)
        variableButtons.forEach { (button) in
            variableStack.addArrangedSubview(button)
        }
        
        accessory.addSubview(accessoryStackView)
        accessoryButtons.forEach { (button) in
            accessoryStackView.addArrangedSubview(button)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        textField.leadingAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.leadingAnchor,
            constant: 10.0).isActive = true
        textField.trailingAnchor.constraint(
            equalTo: self.trailingAnchor).isActive = true
        textField.topAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.topAnchor,
            constant: 10.0).isActive = true
        
        variableStack.topAnchor.constraint(
            equalTo: textField.bottomAnchor,
            constant: 20.0).isActive = true
        variableStack.leadingAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        variableStack.trailingAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        accessoryStackView.leadingAnchor.constraint(equalTo: accessory.leadingAnchor).isActive = true
        accessoryStackView.trailingAnchor.constraint(equalTo: accessory.trailingAnchor).isActive = true
        
        super.updateConstraints()
    }
    
    @objc func insertFromAccessory(sender: UIButton) {
        guard let title = sender.title(for: .normal),
            let inputLabel = InputAccessoryButtonLabels(rawValue: title),
            let selectedRange = textField.selectedTextRange else { return }
        var stringToEnter: String
        var cursorOffset: Int
        switch inputLabel {
            case .sqrt:
                stringToEnter = "√()"
                cursorOffset = 2
            case .openParan:
                stringToEnter = "()"
                cursorOffset = 1
            case .add, .subtract, .multiply, .divide, .closeParan:
                stringToEnter = title
                cursorOffset = 1
        }
        textField.replace(selectedRange, withText: stringToEnter)
        if let newPosition = textField.position(from: selectedRange.start, offset: cursorOffset) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    @objc func insertVariable(sender: UIButton) {
        guard let letter = sender.title(for: .normal),
            let selectedRange = textField.selectedTextRange else { return }
        textField.replace(selectedRange, withText: letter)
        if let newPosition = textField.position(from: selectedRange.start, offset: 1) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
    
}
