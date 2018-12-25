//
//  Parser.swift
//  BREADS
//
//  Created by Dharani Reddy on 12/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

protocol Model {
    var id: String { get }
    var title: String { get }
    var description: String { get }
    var updatedDate: String { get }
}

struct NewsModel : Codable, Model {
    var id: String
    
    var image: String
    
    var title: String
    
    var date: String
    
    var description: String
    
    var updatedDate: String
    
    private enum CodingKeys : String, CodingKey {
        case id = "id", image = "largeimage", title = "title", date = "date", description = "description", updatedDate = "updated_date"
    }
}

struct NewsArray: Codable {
    var news: [NewsModel]
    var success: Int
    
    private enum CodingKeys: String, CodingKey {
        case news = "news", success = "success"
    }
}

struct NotificationModel: Codable, Model {
    var id: String
    
    var title: String
    
    var date: String
    
    var description: String
    
    var updatedDate: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id", title = "title", date = "date", description = "description", updatedDate = "updated_date"
    }
}

struct NotificationArray: Codable {
    var notifications: [NotificationModel]
    var success: Int
    
    private enum CodingKeys: String, CodingKey {
        case notifications = "notification", success = "success"
    }
}

struct VolunteerInternship: Codable, Model {
    var id: String
    
    var title: String
    
    var place: String
    
    var image: String
    
    var description: String
    
    var updatedDate: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id", title = "name", place = "place", image = "image", description = "description", updatedDate = "updated_date"
    }
}

struct VolunteerArray: Codable {
    var volunteerList: [VolunteerInternship]
    var success: Int
    var message: String
    
    private enum CodingKeys: String, CodingKey {
        case volunteerList = "volunteer_testimonals", success = "success", message = "message"
    }
}
struct InternshipArray: Codable {
    var internshipList: [VolunteerInternship]
    var success: Int
    var message: String
    
    private enum CodingKeys: String, CodingKey {
        case internshipList = "internship_testimonials", success = "success", message = "message"
    }
}

struct Project: Codable {
    var id: String
    var name: String
    var image: String
    var updatedDate: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id", name = "name", image = "image", updatedDate = "updated_date"
    }
}

struct ProjectsArray: Codable {
    var success: Int
    var message: String
    var projects: [Project]
    
    private enum CodingKeys: String, CodingKey {
        case projects = "projects", success = "success", message = "message"
    }
}

struct ProjectData: Codable {
    var id: String
    var pId: String
    var title: String
    var description: String
    var image: String
    var date: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id", pId = "p_id", title = "title", description = "description", image = "image", date = "date"
    }
}

struct ProjectDataArray: Codable {
    var success: Int
    var message: String
    var projectData: [ProjectData]
    
    private enum CodingKeys: String, CodingKey {
        case success = "success", message = "message", projectData = "project_data"
    }
}

struct Partner: Codable {
    var id: String
    var logo: String
    var name: String
    var domain: String
    var updatedDate: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id", logo = "logo", name = "name", domain = "domain", updatedDate = "updated_date"
    }
}

struct PartnersArray: Codable {
    var success: Int
    var message: String
    var partners: [Partner]
    
    private enum CodingKeys: String, CodingKey {
        case success = "success", message = "message", partners = "partners"
    }
}

struct AnnualReport: Codable {
    var id: String
    var image: String
    var year: String
    var urlPdf: String
    var updatedDate: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id", image = "image", year = "year", urlPdf = "url_pdf", updatedDate = "updated_date"
    }
}

struct AnnualReportsArray: Codable {
    var success: Int
    var message: String
    var reports: [AnnualReport]
    
    private enum CodingKeys: String, CodingKey {
        case success = "success", message = "message", reports = "annualreport"
    }
}

struct NewsLetter: Codable {
    var id: String
    var image: String
    var date: String
    var name: String
    var urlPdf: String
    var updatedDate: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id", image = "image", date = "date", name = "name", urlPdf = "url_pdf", updatedDate = "updated_date"
    }
}

struct NewsLetterArray: Codable {
    var success: Int
    var message: String
    var letters: [NewsLetter]
    
    private enum CodingKeys: String, CodingKey {
        case success = "success", message = "message", letters = "newsletter"
    }
}

class Parser {
    static let sharedInstance = Parser()
    private init() {}
    
    internal func parseNewsDetail(_ jsonString: String, onSuccess: ([NewsModel]) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(NewsArray.self, from: Data(jsonString.utf8))
            var newsArray: [NewsModel] = []
            for newsObject in decodedData.news {
                let details = NewsModel(id: newsObject.id, image: newsObject.image, title: newsObject.title, date: newsObject.date, description: newsObject.description, updatedDate: newsObject.updatedDate)
                newsArray.append(details)
            }
            onSuccess(newsArray)
        } catch {
            print(error)
        }
    }
    
    internal func parseNotificationDetail(_ jsonString: String, onSuccess: ([NotificationModel]) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(NotificationArray.self, from: Data(jsonString.utf8))
            var notificationArray: [NotificationModel] = []
            for notificationObject in decodedData.notifications {
                let notification = NotificationModel(id: notificationObject.id, title: notificationObject.title, date: notificationObject.date, description: notificationObject.description, updatedDate: notificationObject.updatedDate)
                notificationArray.append(notification)
            }
            onSuccess(notificationArray)
        } catch  {
            print(error)
        }
    }
    
    internal func parseVolunteerList(_ jsonString: String, onSuccess: ([VolunteerInternship]) -> Void) {
        do {
            let decodeData = try JSONDecoder().decode(VolunteerArray.self, from: Data(jsonString.utf8))
            onSuccess(parseVolunteerInternship(objects: decodeData.volunteerList))
        } catch {
            print(error)
        }
    }
    
    internal func parseInternshipList(_ jsonString: String, onSuccess: ([VolunteerInternship]) -> Void) {
        do {
            let decodeData = try JSONDecoder().decode(InternshipArray.self, from: Data(jsonString.utf8))
            onSuccess(parseVolunteerInternship(objects: decodeData.internshipList))
        } catch {
            print(error)
        }
    }
    
    private func parseVolunteerInternship(objects: [VolunteerInternship]) -> [VolunteerInternship] {
        var volunteerInternshipArray: [VolunteerInternship] = []
        for object in objects {
            let volunteerInternship = VolunteerInternship(id: object.id, title: object.title, place: object.place, image: object.image, description: object.description, updatedDate: object.updatedDate)
            volunteerInternshipArray.append(volunteerInternship)
        }
        return volunteerInternshipArray
    }
    
    internal func parseProjects(_ jsonString: String, onSuccess: ([Project]) -> Void) {
        do {
            let decodeData = try JSONDecoder().decode(ProjectsArray.self, from: Data(jsonString.utf8))
            var projectsArray: [Project] = []
            for project in decodeData.projects {
                let projectObject = Project(id: project.id, name: project.name, image: project.image, updatedDate: project.updatedDate)
                projectsArray.append(projectObject)
            }
            onSuccess(projectsArray)
        } catch {
            print(error)
        }
    }
    
    internal func parseProjectData(_ jsonString: String, onSuceess: ([ProjectData]) -> Void) {
        do {
            let decodeData = try JSONDecoder().decode(ProjectDataArray.self, from: Data(jsonString.utf8))
            var projectDataArray: [ProjectData] = []
            for projectData in decodeData.projectData {
                let projectDataObject = ProjectData(id: projectData.id, pId: projectData.pId, title: projectData.title, description: projectData.description, image: projectData.image, date: projectData.date)
                projectDataArray.append(projectDataObject)
            }
            onSuceess(projectDataArray)
        } catch {
            print(error)
        }
    }
    
    internal func parsePartners(_ jsonString: String, onSuccess: ([Partner]) -> Void) {
        do {
            let decodeData = try JSONDecoder().decode(PartnersArray.self, from: Data(jsonString.utf8))
            var partnersArray: [Partner] = []
            for partner in decodeData.partners {
                let partnerObject = Partner(id: partner.id, logo: partner.logo, name: partner.name, domain: partner.domain, updatedDate: partner.updatedDate)
                partnersArray.append(partnerObject)
            }
            onSuccess(partnersArray)
        } catch {
            print(error)
        }
    }
    
    internal func parseAnnualReports(_ jsonString: String, onSuccess: ([AnnualReport]) -> Void) {
        do {
            let decodeData = try JSONDecoder().decode(AnnualReportsArray.self, from: Data(jsonString.utf8))
            var annualReportsArray: [AnnualReport] = []
            for annualReport in decodeData.reports {
                let annualReportObject = AnnualReport(id: annualReport.id, image: annualReport.image, year: annualReport.year, urlPdf: annualReport.urlPdf, updatedDate: annualReport.updatedDate)
                annualReportsArray.append(annualReportObject)
            }
            onSuccess(annualReportsArray)
        } catch {
            print(error)
        }
    }
    
    internal func parseNewsLetters(_ jsonString: String, onSuccess: ([NewsLetter]) -> Void) {
        do {
            let decodeData = try JSONDecoder().decode(NewsLetterArray.self, from: Data(jsonString.utf8))
            var newsLetterArray: [NewsLetter] = []
            for newsLetter in decodeData.letters {
                let newsLetterObject = NewsLetter(id: newsLetter.id, image: newsLetter.image, date: newsLetter.date, name: newsLetter.name, urlPdf: newsLetter.urlPdf, updatedDate: newsLetter.updatedDate)
                newsLetterArray.append(newsLetterObject)
            }
            onSuccess(newsLetterArray)
        } catch {
            print(error)
        }
    }
}
