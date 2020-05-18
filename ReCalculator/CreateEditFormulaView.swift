//
//  CreateEditFormulaView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 5/12/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import UIKit

class CreateEditFormulaView: UIView {
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Formula"
        textField.keyboardType = .decimalPad
        textField.font = .boldSystemFont(ofSize: 20.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        return textField
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
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        //Set child views
        addSubview(textField)
        addSubview(variableStack)
        variableButtons.forEach { (button) in
            variableStack.addArrangedSubview(button)
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
        
        super.updateConstraints()
    }
    
    @objc func insertVariable(sender: UIButton) {
        guard let letter = sender.title(for: .normal) else { return }
        textField.insert(text: letter)
    }
    
}
