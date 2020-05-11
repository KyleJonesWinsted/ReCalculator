//
//  CreateEditFormulaViewController.swift
//  ReCalculator
//
//  Created by Kyle Jones on 5/10/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import UIKit
import SwiftUI

enum InputAccessoryButtonLabels: String, CaseIterable {
    case sqrt = "√"
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    case openParan = "("
    case closeParan = ")"
}

class CreateEditFormulaViewController: UIViewController {

    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
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
    
    let accessoryStackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func loadView() {
        textField.inputAccessoryView = accessory
            
        //Set child views
        topView.addSubview(textField)
        accessory.addSubview(accessoryStackView)
        accessoryButtons.forEach { (button) in
            accessoryStackView.addArrangedSubview(button)
        }
        
        //Set Constraints
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(
            equalTo: topView.safeAreaLayoutGuide.leadingAnchor,
            constant: 10.0).isActive = true
        textField.trailingAnchor.constraint(
            equalTo: topView.trailingAnchor).isActive = true
        textField.topAnchor.constraint(
            equalTo: topView.safeAreaLayoutGuide.topAnchor,
            constant: 10.0).isActive = true
        
        accessoryStackView.leadingAnchor.constraint(equalTo: accessory.leadingAnchor).isActive = true
        accessoryStackView.trailingAnchor.constraint(equalTo: accessory.trailingAnchor).isActive = true
        
        self.view = topView
        
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

}


#if DEBUG
struct CreateEditFormulaViewController_Previews: PreviewProvider {
    static var previews: some View {
        CreateEditFormulaViewRepresentable()
    }
    
    struct CreateEditFormulaViewRepresentable: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<CreateEditFormulaViewController_Previews.CreateEditFormulaViewRepresentable>) -> UIViewController {
            return CreateEditFormulaViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CreateEditFormulaViewController_Previews.CreateEditFormulaViewRepresentable>) {
            return
        }
        
        typealias UIViewControllerType = UIViewController
        
    }
}
#endif



