//
//  CreateEditFormulaViewController.swift
//  ReCalculator
//
//  Created by Kyle Jones on 5/10/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import UIKit
import SwiftUI


class CreateEditFormulaViewController: UIViewController, MathInputAccessoryViewDelegate {
    
    let createEditFormulaView = CreateEditFormulaView()
    let mathInputAccessory = MathInputAccessoryView()

    override func loadView() {
        view = createEditFormulaView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mathInputAccessory.delegate = self
        createEditFormulaView.textField.inputAccessoryView = mathInputAccessory
        createEditFormulaView.textField.becomeFirstResponder()
        
    }
    
    func inputSymbolFromAccessory(sender: UIButton) {
        guard let title = sender.title(for: .normal),
            let inputLabel = InputAccessoryButtonLabels(rawValue: title) else { return }
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
        createEditFormulaView.textField.insert(text: stringToEnter, cursorOffset: cursorOffset)
    }
}



