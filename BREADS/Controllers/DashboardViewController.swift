//
//  DashboardViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 10/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

let screenWidth     = UIScreen.main.bounds.width
let screenHeight    = UIScreen.main.bounds.height
let iPhoneSE        = screenHeight == 568.0
let iPhoneStandard           =   UIScreen.main.bounds.height == 667.0

class DashboardViewController: BaseViewController {

    // MARK:- Varibales
    private var news: [NewsModel] = []
    private var notifications: [NotificationModel] = []
    private var activityController : UIActivityViewController!
    private var isNotifiedAlertDismissed = true
    
    // MARK:- IBOutlets
    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet private weak var contactUsView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var newsTableView: UITableView!
    @IBOutlet private weak var notificationsTableView: UITableView!
    @IBOutlet private weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationTitle()
        newsTableView.estimatedRowHeight = 263
        newsTableView.rowHeight = UITableView.automaticDimension
        notificationsTableView.estimatedRowHeight = 87
        notificationsTableView.rowHeight = UITableView.automaticDimension
        slideMenuController()?.changeLeftViewWidth(screenWidth-screenWidth/5)
        SlideMenuOptions.contentViewScale = 1.0
        getNews()
        getNotifications()
        loadWebView()
        loadActivityController()
        (UIApplication.shared.delegate as? AppDelegate)?.dashboard = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isNotificationYetToReachItsDestination()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK:- Private Methods
    private func animateIndicator(index: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.indicatorViewLeadingConstraint.constant = index * (screenWidth/4)
            self.view.layoutIfNeeded()
        })
    }
    
    private func animateScrollView(point: CGPoint) {
        scrollView.setContentOffset(point, animated: true)
    }
    
    private func getNews() {
        APICaller.getInstance().getNews(onSuccess: { news in
            self.news = news
            self.newsTableView.reloadData()
        }, onError: { _ in })
    }
    
    private func getNotifications() {
        APICaller.getInstance().getNotifications(onSuccess: { notifications in
            self.notifications = notifications
            self.notificationsTableView.reloadData()
        }, onError: { _ in })
    }
    
    private func loadWebView() {
        let urlRequest = NSURLRequest(url: NSURL(string: "http://www.breadsbangalore.org/")! as URL)
        webView.loadRequest(urlRequest as URLRequest)
    }
    
    private func loadActivityController() {
        let url = URL(string: "https://appstoreconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1449406290")!
        let activityItems = ["Help children fulfill their dreams. Support their education. Download this app to donate and spread the word among your friends. Thank you! \n", url] as [Any]
        activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityController.excludedActivityTypes = [.print, .copyToPasteboard, .assignToContact, .saveToCameraRoll, .addToReadingList]
    }
    
    private func navigationTitle() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HiraMinProN-W6", size: getFontSize())!, NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func callNumber(number: String) {
        if let url = URL(string: "telprompt:\(number)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
    
    // MARK:- IBActions
    @IBAction private func menuButton_Tapped() {
        slideMenuController()?.openLeft()
    }
    
    @IBAction private func tabBarButton_Tapped(button: UIButton) {
        let tag = CGFloat(button.tag)
        animateIndicator(index: tag)
        animateScrollView(point: CGPoint(x: tag * screenWidth, y: 0))
        
    }
    
    @IBAction private func swipeGestureRecognizer(gesture: UISwipeGestureRecognizer) {
        let currentXPoint = scrollView.contentOffset.x
        let xPoint = gesture.direction == .left ? currentXPoint+screenWidth : currentXPoint-screenWidth
        guard xPoint >= 0 && xPoint <= screenWidth*3 else { return }
        animateIndicator(index: xPoint/screenWidth)
        animateScrollView(point: CGPoint(x: xPoint, y: 0))
    }
    
    @IBAction private func callUsButton_Tapped() {
        let callAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let firstNumberAction = UIAlertAction(title: "+91-8025463476", style: .default, handler: { _ in
            self.callNumber(number: "+91-8025463476")
        })
        let secondNumberAction = UIAlertAction(title: "+91-8025805551", style: .default, handler: { _ in
            self.callNumber(number: "+91-8025805551")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        callAlert.addAction(firstNumberAction)
        callAlert.addAction(secondNumberAction)
        callAlert.addAction(cancelAction)
        present(callAlert, animated: true, completion: nil)
    }
    
    @IBAction private func emailButton_Tapped() {
        let email = "info@breadsbangalore.org"
        if let url = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
}

// MARK:- Dashboard
extension DashboardViewController {
    @IBAction private func whoWeAreButton_Tapped() {
        let webViewController = UIStoryboard.loadWhoWeAreViewController()
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @IBAction private func shareButton_Tapped() {
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction private func mediaButton_Tapped() {
        let mediaViewController = UIStoryboard.loadMediaViewController()
        navigationController?.pushViewController(mediaViewController, animated: true)
    }
    
    @IBAction private func donateButton_Tapped() {
        pushWebViewController(urlString: "http://breadsdonations.com/profile.php")
    }
    
    @IBAction private func joinUsButton_Tapped() {
        let controller = UIStoryboard.loadVolunteerInternshipController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction private func contactUsButton_Tapped(button: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.contactUsView.alpha = CGFloat(button.tag)
        })
    }
}

// MARK:- News, Notifications
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == newsTableView ? news.count : notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == newsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableCell.self)) as? NewsTableCell
            cell?.loadNewsInfo(newsInfo: news[indexPath.row])
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationTableCell.self)) as? NotificationTableCell
            cell?.loadData(notification: notifications[indexPath.row])
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView == newsTableView else { return }
        let newsDetailedController = UIStoryboard.loadNewsDetailViewController()
        newsDetailedController.news = news[indexPath.row]
        navigationController?.pushViewController(newsDetailedController, animated: true)
    }
}

// MARK:- Web
extension DashboardViewController {
}

class NewsTableCell: UITableViewCell {
    // MARK:- IBOutlets
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsDescriptionLabel: UILabel!
    @IBOutlet private weak var newsDateLabel: UILabel!
    
    // MARK:- Private Methods
    fileprivate func loadNewsInfo(newsInfo: NewsModel) {
        newsImageView.image = #imageLiteral(resourceName: "news_bg")
        newsImageView.downloadImageFrom(link: newsInfo.image, contentMode: .scaleAspectFill)
        newsTitleLabel.text = newsInfo.title
        newsDescriptionLabel.text = newsInfo.description
        newsDateLabel.text = newsInfo.date
    }
}

class NotificationTableCell: UITableViewCell {
    // MARK:- IBOutlets
    @IBOutlet private weak var notificationDateLabel: UILabel!
    @IBOutlet private weak var notificationTitleLabel: UILabel!
    @IBOutlet private weak var notificationDescriptionLabel: UILabel!
    @IBOutlet private weak var notificationDescriptionTextView: UITextView!
    
    // MARK:- Private Methods
    fileprivate func loadData(notification: NotificationModel) {
        notificationTitleLabel.text = notification.title
        notificationDescriptionLabel.text = notification.description
        notificationDescriptionTextView.text = notification.description
        notificationDateLabel.text = notification.date
    }
}

// MARK:- Push Notifications
extension DashboardViewController {
    /**
     Before notification going to invoke its controller, basic checks needs to be verified and notificaton will be fired.
     */
    internal func postRemoteNotification() {
        
        // Check Notification is recieved while app is foreground
        if isNotifiedAlertDismissed {
            self.isNotifiedAlertDismissed = false
            // Pop's up the alertview and notifiy user to whether he/she wants to reach notified controller
            guard TopViewController.isNotifiedController() else {
                showAlertViewController(getAlertTitle(), message: truncateCharactersInNotificationMessage(PushNotificationHandler.sharedInstance.notificationMessage as NSString), cancelButton: "Close", destructiveButton: "", otherButtons: "Open", onDestroyAction: {
                    self.isNotifiedAlertDismissed = true
                    PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
                    self.presentNotifiedViewController()
                }, onCancelAction: {
                    self.isNotifiedAlertDismissed = true
                    // Making sure app is reached its destination view controller, so that future notifications will show
                    PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
                })
                return
            }
            isNotifiedAlertDismissed = true
            PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
        } else if isNotifiedAlertDismissed {
            
            //Looks for destined notification controller
            presentNotifiedViewController()
        } else {
            // Making sure app is reached its destination view controller, so that future notifications will show
            PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
        }
    }
    /**
     To confirm whether notification reached its destined controller.
     */
    private func isNotificationYetToReachItsDestination() {
        if PushNotificationHandler.sharedInstance.isPushNotificationRecieved {
            postRemoteNotification()
        }
    }
    
    internal func presentNotifiedViewController() {
        //1 Projects
        //2 Annual Reports
        //3 News Letter
        //4 News
        //5 Notifications
        
        print(PushNotificationHandler.sharedInstance.notificationType)
        PushNotificationHandler.sharedInstance.isPushNotificationRecieved = false
        let type = PushNotificationHandler.sharedInstance.notificationType
        switch type {
        case 1:
            loadProjectsController()
        case 2:
            loadPublicationsController(isReports: true)
        case 3:
            loadPublicationsController(isReports: false)
        case 4:
            loadTabBars(1)
        case 5:
            loadTabBars(2)
        default:
            break
        }
    }
    
    private func loadTabBars(_ type: CGFloat) {
        animateIndicator(index: type)
        animateScrollView(point: CGPoint(x: type * screenWidth, y: 0))
    }
    
    private func getAlertTitle() -> String {
        switch PushNotificationHandler.sharedInstance.notificationType {
        case 1:
            return "Projects"
        case 2:
            return "Annual Reports"
        case 3:
            return "News Letter"
        case 4:
            return "News"
        case 5:
            return "Notifications"
        default:
            return "BREADS"
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
