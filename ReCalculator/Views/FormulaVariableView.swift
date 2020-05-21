//
//  FormulaVariableView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 5/20/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import UIKit

protocol FormulaVariableViewDelegate {
    func insertVariable(sender: UIButton)
}

class FormulaVariableView: UIView {
    
    var delegate: FormulaVariableViewDelegate?
    
    let button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44.0, height: 44.0))
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(title: Character) {
        super.init(frame: .zero)
                
        button.setTitle(String(title), for: .normal)
        button.addTarget(self, action: #selector(insertVariable(sender:)), for: .touchUpInside)
                
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        super.updateConstraints()
    }
    
    @objc func insertVariable(sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.insertVariable(sender: sender)
    }
    
}
