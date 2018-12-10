//
//  DashboardViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 10/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class DashboardViewController: UIViewController {

    // MARK:- IBOutlets
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK:- IBActions
    @IBAction private func menuButton_Tapped() {
        slideMenuController()?.openLeft()
    }
}
