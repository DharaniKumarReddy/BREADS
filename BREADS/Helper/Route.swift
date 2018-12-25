//
//  Route.swift
//  ICYM
//
//  Created by Dharani Reddy on 14/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

let Base_Url = "http://breadsdonations.com"

enum Route {
    case news
    case notifications
    case volunteer
    case internship
    case projects
    case projectList
    case partners
    case newsLetter
    case annualReport
    
    var absoluteURL: URL {
        return URL(string: Base_Url + apiPath)!
    }
    
    private var apiPath: String {
        switch self {
        case .news:
            return "/breads_news.php"
        case .notifications:
            return "/breads_notification.php"
        case .volunteer:
            return "/breads_volunteer.php"
        case .internship:
            return "/breads_internship.php"
        case .projects:
            return "/breads_projects.php"
        case .projectList:
            return "/breads_project1.php"
        case .partners:
            return "/breads_partners.php"
        case .newsLetter:
            return "/breads_newsletter.php"
        case .annualReport:
            return "/breads_annualreport.php"
        }
    }
}
