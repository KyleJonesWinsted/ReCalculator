//
//  MathInputAccessoryView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 5/17/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import UIKit

protocol MathInputAccessoryViewDelegate {
    func inputSymbolFromAccessory(sender: UIButton)
}

enum InputAccessoryButtonLabels: String, CaseIterable {
    case sqrt = "√"
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    case openParan = "("
    case closeParan = ")"
}

class MathInputAccessoryView: UIView {
    
    var delegate: MathInputAccessoryViewDelegate?
    
    let accessoryButtons: [UIButton] = {
        var buttons = [UIButton]()
        for label in InputAccessoryButtonLabels.allCases {
            let button = UIButton()
            button.setTitle(label.rawValue, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.white, for: .highlighted)
            button.addTarget(self, action: #selector(insertFromAccessory), for: .touchUpInside)
            buttons.append(button)
        }
        return buttons
    }()
    
    let accessoryStackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 40.0))
        
        backgroundColor = .systemGray5
        
        addSubview(accessoryStackView)
        accessoryButtons.forEach { (button) in
            accessoryStackView.addArrangedSubview(button)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        accessoryStackView.anchor(leading: leadingAnchor, trailing: trailingAnchor)
        
        super.updateConstraints()
    }
    
    @objc func insertFromAccessory(sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.inputSymbolFromAccessory(sender: sender)
    }
    
}
