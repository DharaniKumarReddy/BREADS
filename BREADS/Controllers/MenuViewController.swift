//
//  MenuViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 10/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK:- IBActions
    @IBAction private func projectsButton_Tapped() {
        slideMenuController()?.closeLeft()
        let projectsViewController = UIStoryboard.loadProjectsViewController()
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(projectsViewController, animated: true)
    }
    
    @IBAction private func partnersButoon_Tapped() {
        slideMenuController()?.closeLeft()
        let partnersViewController = UIStoryboard.loadPartnersViewController()
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(partnersViewController, animated: true)
    }
    
    @IBAction private func publicationsButton_Tapped() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let callAction = UIAlertAction(title: "Annual Report", style: .default, handler: { _ in
            
        })
        let emailAction = UIAlertAction(title: "News Letter", style: .default, handler: { _ in
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            
        })
        controller.addAction(callAction)
        controller.addAction(emailAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction private func presenceButton_Tapped() {
        slideMenuController()?.closeLeft()
        let presenceViewController = UIStoryboard.loadPresenceViewController()
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(presenceViewController, animated: true)
    }
}
