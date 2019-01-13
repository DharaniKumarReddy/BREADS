//
//  APICaller.swift
//  ICYM
//
//  Created by Dharani Reddy on 14/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

typealias OnSuccessResponse = (String) -> Void
typealias OnDestroySuccess = () -> Void
typealias OnCancelSuccess = () -> Void
typealias OnErrorMessage = (String) -> Void

typealias JSONDictionary = [String : AnyObject]

private enum RequestMethod: String, CustomStringConvertible {
    case GET = "GET"
    case PUT = "PUT"
    case POST = "POST"
    case DELETE = "DELETE"
    case PATCH  = "PATCH"
    
    var description: String {
        return rawValue
    }
}

class APICaller {
    let MAX_RETRIES = 2
    
    fileprivate var urlSession: URLSession
    
    class func getInstance() -> APICaller {
        struct Static {
            static let instance = APICaller()
        }
        return Static.instance
    }
    
    fileprivate init() {
        urlSession = APICaller.createURLSession()
    }
    
    fileprivate class func createURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        //        configuration.httpAdditionalHeaders = [
        //            "Accept"       : "application/json",
        //        ]
        
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    fileprivate func resetURLSession() {
        urlSession.invalidateAndCancel()
        urlSession = APICaller.createURLSession()
    }
    
    fileprivate func createRequest(_ requestMethod: RequestMethod, _ route: Route, params: JSONDictionary? = nil) -> URLRequest {
        let request = NSMutableURLRequest(url: route.absoluteURL as URL)
        request.httpMethod = requestMethod.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let params = params {
            switch requestMethod {
            case .GET, .DELETE:
                var queryItems: [URLQueryItem] = []
                
                for (key, value) in params {
                    queryItems.append(URLQueryItem(name: "\(key)", value: "\(value)"))
                }
                
                if queryItems.count > 0 {
                    var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
                    components?.queryItems = queryItems
                    request.url = components?.url
                }
                
            case .POST, .PUT, .PATCH:
                var bodyParams = ""
                for (key, value) in params {
                    bodyParams += "\(key)=" + "\(value)"
                }
                let postData = bodyParams.data(using: String.Encoding.ascii, allowLossyConversion: true)!
                //let body = try JSONSerialization.data(withJSONObject: params, options: [])
                request.httpBody = postData
            }
        }
        return request as URLRequest
    }
    
    fileprivate func enqueueRequest(_ requestMethod: RequestMethod, _ route: Route, params: JSONDictionary? = nil, retryCount: Int = 0, onSuccessResponse: @escaping (String) -> Void, onErrorMessage: @escaping OnErrorMessage) {
        
        let urlRequest = createRequest(requestMethod, route, params: params)
        print("URL-> \(urlRequest)")
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                var statusCode = httpResponse.statusCode
                var responseString:String = ""
                if let responseData = data {
                    responseString = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue) as String? ?? ""
                }else {
                    statusCode = 450
                }
                print(responseString)
                switch statusCode {
                case 200...299:
                    // Success Response
                    
                    onSuccessResponse(responseString)
                    
                    
                default:
                    // Failure Response
                    let errorMessage = "Error Code: \(statusCode)"
                    onErrorMessage(errorMessage)
                }
                
            } else if let error = error {
                var errorMessage: String
                switch error._code {
                case NSURLErrorNotConnectedToInternet:
                    errorMessage = "Net Lost"//Constant.ErrorMessage.InternetConnectionLost
                case NSURLErrorNetworkConnectionLost:
                    if retryCount < self.MAX_RETRIES {
                        self.enqueueRequest(requestMethod, route, params: params, retryCount: retryCount + 1, onSuccessResponse: onSuccessResponse, onErrorMessage: onErrorMessage)
                        return
                        
                    } else {
                        errorMessage = error.localizedDescription
                    }
                default:
                    errorMessage = error.localizedDescription
                }
                onErrorMessage(errorMessage)
                
            } else {
                assertionFailure("Either an httpResponse or an error is expected")
            }
        })
        dataTask.resume()
    }
    
    internal func getNews(onSuccess: @escaping ([NewsModel]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .news, params: ["updated_at":"2017-11-13 03:36:13" as AnyObject],
            onSuccessResponse: { response in
                Parser.sharedInstance.parseNewsDetail(response, onSuccess: { news in
                    onSuccess(news)
                })
        }, onErrorMessage: {error in
            onError(error)
        })
    }
    
    internal func getNotifications(onSuccess: @escaping ([NotificationModel]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .notifications, params: ["updated_at":"2017-11-13 03:36:13" as AnyObject],
            onSuccessResponse: { response in
                Parser.sharedInstance.parseNotificationDetail(response, onSuccess: { notifications in
                    onSuccess(notifications)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getVolunteerData(onSuccess: @escaping ([VolunteerInternship]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .volunteer, onSuccessResponse: { response in
                Parser.sharedInstance.parseVolunteerList(response, onSuccess: { volunteerList in
                    onSuccess(volunteerList)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getInternshipData(onSuccess: @escaping ([VolunteerInternship]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .internship, onSuccessResponse: { response in
                Parser.sharedInstance.parseInternshipList(response, onSuccess: { internshipList in
                    onSuccess(internshipList)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getProjects(onSuccess: @escaping ([Project]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .projects, params: ["updated_at":"2017-11-15 21:25:33" as AnyObject],
            onSuccessResponse: { response in
                Parser.sharedInstance.parseProjects(response, onSuccess: { projects in
                    onSuccess(projects)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getProjectList(projectId: String?, onSuccess: @escaping ([ProjectData]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .projectList, params: ["p_id" : (projectId ?? "") as AnyObject],
            onSuccessResponse: { response in
                Parser.sharedInstance.parseProjectData(response, onSuceess: { projectDataList in
                    onSuccess(projectDataList)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getPartners(onSuccess: @escaping ([Partner]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .partners, params: ["updated_at" : "2017-11-18 01:20:15" as AnyObject],
            onSuccessResponse: { response in
                Parser.sharedInstance.parsePartners(response, onSuccess: { partners in
                    onSuccess(partners)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getAnnualReport(onSuccess: @escaping ([AnnualReport]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .annualReport, params: ["updated_at" : "2017-11-22 03:43:56" as AnyObject],
            onSuccessResponse: { response in
                Parser.sharedInstance.parseAnnualReports(response, onSuccess: { reports in
                    onSuccess(reports)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getNewsLetter(onSuccess: @escaping ([NewsLetter]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .newsLetter, params: ["updated_at" : "2017-11-22 03:43:56" as AnyObject],
            onSuccessResponse: { response in
                Parser.sharedInstance.parseNewsLetters(response, onSuccess: { letters in
                    onSuccess(letters)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getGalleryPhotos(onSuccess: @escaping ([Photo]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .photos, params: ["updated_at" : "2017-11-15 21:25:33" as AnyObject],
            onSuccessResponse: { response in
                Parser.sharedInstance.parseGalleryPhotos(response, onSuccess: { photos in
                    onSuccess(photos)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getVideos(onSuccess: @escaping ([Video]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .videos, params: ["updated_at" : "2017-11-18 02:28:09" as AnyObject],
            onSuccessResponse: { response in
                Parser.sharedInstance.parseVideos(response, onSuccess: { videos in
                    onSuccess(videos)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getGalleryHomeList(galleryId: String, onSuccess: @escaping ([GalleryPhoto]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .galleryHome, params: ["g_id" : galleryId as AnyObject],
            onSuccessResponse: { response in
                Parser.sharedInstance.parseGalleryList(response, onSuccess: { images in
                    onSuccess(images)
                })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
}
