//
//  UIStoryboardExtension.swift
//  BREADS
//
//  Created by Dharani Reddy on 12/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum Storyboard : String {
    case main = "Main"
    // add enum case for each storyboard in your project
}

fileprivate extension UIStoryboard {
    
    static func loadFromMain(_ identifier: String) -> UIViewController {
        return load(from: .main, identifier: identifier)
    }
    
    // optionally add convenience methods for other storyboards here ...
    
    // ... or use the main loading method directly when
    // instantiating view controller from a specific storyboard
    static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
}

// MARK: App View Controllers

extension UIStoryboard {
    class func loadNewsDetailViewController() -> NewsDetailedViewController {
        return loadFromMain(String(describing: NewsDetailedViewController.self)) as! NewsDetailedViewController
    }
    
    class func loadWebViewController() -> WebViewController {
        return loadFromMain(String(describing: WebViewController.self)) as! WebViewController
    }
    
    class func loadVolunteerInternshipController() -> VolunteerInternshipViewController {
        return loadFromMain(String(describing: VolunteerInternshipViewController.self)) as! VolunteerInternshipViewController
    }
    
    class func loadVolunteerInternshipSlideViewController() -> VolunteerInternshipSlideViewController {
        return loadFromMain(String(describing: VolunteerInternshipSlideViewController.self)) as! VolunteerInternshipSlideViewController
    }
    
    class func loadWhoWeAreViewController() -> WhoWeAreViewController {
        return loadFromMain(String(describing: WhoWeAreViewController.self)) as! WhoWeAreViewController
    }
    
    class func loadMediaViewController() -> MediaViewController {
        return loadFromMain(String(describing: MediaViewController.self)) as! MediaViewController
    }
    
    class func loadProjectsViewController() -> ProjectsViewController {
        return loadFromMain(String(describing: ProjectsViewController.self)) as! ProjectsViewController
    }
    
    class func loadProjectDataListViewController() -> ProjectDataListViewController {
        return loadFromMain(String(describing: ProjectDataListViewController.self)) as! ProjectDataListViewController
    }
    
    class func loadPartnersViewController() -> PartnersViewController {
        return loadFromMain(String(describing: PartnersViewController.self)) as! PartnersViewController
    }
    
    class func loadPresenceViewController() -> PresenceViewController {
        return loadFromMain(String(describing: PresenceViewController.self)) as! PresenceViewController
    }
    
    class func loadPublicationsViewController() -> AnnualReportNewsLetterViewController {
        return loadFromMain(String(describing: AnnualReportNewsLetterViewController.self)) as! AnnualReportNewsLetterViewController
    }
    
    class func loadPhotosViewController() -> PhotosViewController {
        return loadFromMain(String(describing: PhotosViewController.self)) as! PhotosViewController
    }
}
