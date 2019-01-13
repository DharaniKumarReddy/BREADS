//
//  UIViewControllerExtension.swift
//  BREADS
//
//  Created by Dharani Reddy on 17/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func navigationBackWithNoText() {
        let barButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(popViewController))
        barButton.image = UIImage(named: "UINavigationBarBackIndicatorDefault")
        barButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func popViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func showAlertViewController(_ title: String, message: String, cancelButton: String, destructiveButton: String!, otherButtons:String!, onDestroyAction: @escaping OnDestroySuccess, onCancelAction: @escaping OnCancelSuccess) {
        
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        let cancelAction    = UIAlertAction(title: NSLocalizedString(cancelButton, comment: ""), style: .cancel) { alertAction in
            onCancelAction()
        }
        alertController.addAction(cancelAction)
        
        var alertAction:UIAlertAction!
        
        if let nonDestructiveButton = otherButtons {
            alertAction = UIAlertAction(title: nonDestructiveButton, style: .default) { alertAction in
                onDestroyAction()
            }
            alertController.addAction(alertAction)
        } else if let destructiveButton = destructiveButton {
            // Apple says when most likely button is destructive it should be on the left
            alertAction = UIAlertAction(title: NSLocalizedString(destructiveButton, comment: ""), style: .destructive) { alertAction in
                onDestroyAction()
            }
            alertController.addAction(alertAction)
        }
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.present(alertController, animated: true)
        }
    }
    
    internal func loadProjectsController() {
        let projectsViewController = UIStoryboard.loadProjectsViewController()
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(projectsViewController, animated: true)
    }
    
    internal func loadPublicationsController(isReports: Bool) {
        let controller = UIStoryboard.loadPublicationsViewController()
        controller.isReports = isReports
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(controller, animated: true)
    }
}
