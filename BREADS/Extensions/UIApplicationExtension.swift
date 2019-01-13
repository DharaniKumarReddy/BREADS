//
//  UIApplicationExtension.swift
//  BREADS
//
//  Created by Dharani Reddy on 11/01/19.
//  Copyright © 2019 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController() -> UIViewController? {
        let topController = (UIApplication.shared.keyWindow?.rootViewController?.children.first as? UINavigationController)?.visibleViewController
        if topController?.children.count != 0 {
            return topController?.children.last
        } else {
            return topController
        }
    }
}
