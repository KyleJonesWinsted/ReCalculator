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
        textField.anchor(top: safeAreaLayoutGuide.topAnchor, topConstant: 10.0,
                         leading: safeAreaLayoutGuide.leadingAnchor, leadingConstant: 10.0,
                         trailing: safeAreaLayoutGuide.trailingAnchor, trailingConstant: -10.0)
        
        variableStack.anchor(top: textField.bottomAnchor, topConstant: 20.0,
                             leading: safeAreaLayoutGuide.leadingAnchor,
                             trailing: safeAreaLayoutGuide.trailingAnchor)
        
        variables.forEach { (variable) in
            variable.anchor(leading: variableStack.leadingAnchor,
                            trailing: variableStack.trailingAnchor)
        }
        
        super.updateConstraints()
    }
    
    func insertVariable(sender: UIButton) {
        guard let letter = sender.title(for: .normal) else { return }
        textField.insert(character: Character(letter))
    }
        
}
