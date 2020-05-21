//
//  UIKitExtensions.swift
//  ReCalculator
//
//  Created by Kyle Jones on 5/17/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func insert(text: String, cursorOffset: Int = 1) {
        guard let selectedRange = selectedTextRange else { return }
        replace(selectedRange, withText: text)
        if let newPosition = position(from: selectedRange.start, offset: cursorOffset) {
            selectedTextRange = textRange(from: newPosition, to: newPosition)
        }
    }
    
    func insert(character: Character) {
        insert(text: String(character))
    }
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                topConstant: CGFloat = 0.0,
                bottom: NSLayoutYAxisAnchor? = nil,
                bottomConstant: CGFloat = 0.0,
                leading: NSLayoutXAxisAnchor? = nil,
                leadingConstant: CGFloat = 0.0,
                trailing: NSLayoutXAxisAnchor? = nil,
                trailingConstant: CGFloat = 0.0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top,
                                 constant: topConstant).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom,
                                    constant: bottomConstant).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading,
                                     constant: leadingConstant).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing,
                                      constant: trailingConstant).isActive = true
        }
    }
}
