//
//  MenuViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 10/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MenuViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK:- IBActions
    @IBAction private func projectsButton_Tapped() {
        slideMenuController()?.closeLeft()
        loadProjectsController()
    }
    
    @IBAction private func partnersButoon_Tapped() {
        slideMenuController()?.closeLeft()
        let partnersViewController = UIStoryboard.loadPartnersViewController()
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(partnersViewController, animated: true)
    }
    
    @IBAction private func publicationsButton_Tapped() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let reportAction = UIAlertAction(title: "Annual Report", style: .default, handler: { _ in
            self.loadPublications(isReports: true)
        })
        let letterAction = UIAlertAction(title: "News Letter", style: .default, handler: { _ in
            self.loadPublications(isReports: false)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { _ in
        })
        controller.addAction(reportAction)
        controller.addAction(letterAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction private func presenceButton_Tapped() {
        slideMenuController()?.closeLeft()
        let presenceViewController = UIStoryboard.loadPresenceViewController()
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(presenceViewController, animated: true)
    }
    
    @IBAction private func socialButton_Tapped(button: UIButton) {
        slideMenuController()?.closeLeft()
        let webUrl = ["https://www.facebook.com/breadsbangalore.org/", "https://twitter.com/donboscobreads", "https://www.youtube.com/channel/UC5mMJjSpsrdIMEInAk7dfHw"][button.tag]
        let webViewController = UIStoryboard.loadWebViewController()
        webViewController.webUrl = webUrl
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(webViewController, animated: true)
    }
    
    // MARK:- Private Methods
    private func loadPublications(isReports: Bool) {
        slideMenuController()?.closeLeft()
        loadPublicationsController(isReports: isReports)
    }
}
