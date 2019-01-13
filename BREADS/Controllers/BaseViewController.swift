//
//  BaseViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 17/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    internal func pushWebViewController(urlString: String?) {
        let webViewController = UIStoryboard.loadWebViewController()
        webViewController.webUrl = urlString
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
