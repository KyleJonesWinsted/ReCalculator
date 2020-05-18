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
}
