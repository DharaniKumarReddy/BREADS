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
}
