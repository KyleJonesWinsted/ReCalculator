//
//  CreateEditFormulaView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 5/12/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import UIKit

class CreateEditFormulaView: UIView, FormulaVariableViewDelegate {
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Formula"
        textField.keyboardType = .decimalPad
        textField.font = .boldSystemFont(ofSize: 30.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        return textField
    }()
    
    let variables: [FormulaVariableView] = {
        var variables = [FormulaVariableView]()
        var tempLetters = "abcde"
        for char in tempLetters {
            let variable = FormulaVariableView(title: Character(char.description))
            variables.append(variable)
        }
        return variables
    }()
    
    let variableStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        //Set child views
        addSubview(textField)
        addSubview(variableStack)
        variables.forEach { (variable) in
            variable.delegate = self
            variableStack.addArrangedSubview(variable)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        textField.leadingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leadingAnchor,
            constant: 10.0).isActive = true
        textField.trailingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.trailingAnchor,
            constant: -10.0).isActive = true
        textField.topAnchor.constraint(
            equalTo: safeAreaLayoutGuide.topAnchor,
            constant: 10.0).isActive = true
        
        variableStack.topAnchor.constraint(
            equalTo: textField.bottomAnchor,
            constant: 20.0).isActive = true
        variableStack.leadingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        variableStack.trailingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        variables.forEach { (variable) in
            variable.leadingAnchor.constraint(equalTo: variableStack.leadingAnchor).isActive = true
            variable.trailingAnchor.constraint(equalTo: variableStack.trailingAnchor).isActive = true
        }
        
        super.updateConstraints()
    }
    
    func insertVariable(sender: UIButton) {
        guard let letter = sender.title(for: .normal) else { return }
        textField.insert(character: Character(letter))
    }
        
}
