//
//  CreateEditFormulaViewController.swift
//  ReCalculator
//
//  Created by Kyle Jones on 5/10/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import UIKit
import SwiftUI


class CreateEditFormulaViewController: UIViewController {
    
    let createEditFormulaView = CreateEditFormulaView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func loadView() {
        self.view = createEditFormulaView
        
    }

}



