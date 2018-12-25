//
//  VolunteerInternshipViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 17/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class VolunteerInternshipViewController: UIViewController {

    // MARK:- Variables
    private var volunteerList: [VolunteerInternship] = []
    private var internshipList: [VolunteerInternship] = []
    private var volunteerSlidePageViewController: VolunteerInternshipPageViewController?
    private var internshipSlidePageViewController: VolunteerInternshipPageViewController?
    
    // MARK:- IBOuttlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var volunteerWebView: UIWebView!
    @IBOutlet private weak var internshipWebView: UIWebView!
    @IBOutlet private weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        getVolunteerList()
        getInternshipData()
        loadVolunteerWebView()
        loadInternshipWebView()
        animateIndicatorView(index: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let slidePageVC = segue.destination as? VolunteerInternshipPageViewController, segue.identifier == "volunteer" {
            volunteerSlidePageViewController = slidePageVC
        } else if let slidePageVC = segue.destination as? VolunteerInternshipPageViewController {
            internshipSlidePageViewController = slidePageVC
        }
    }
    
    // MARK:- Private Methods
    private func getVolunteerList() {
        APICaller.getInstance().getVolunteerData(onSuccess: { list in
            self.volunteerList = list
            self.loadVolunteerSlidePageViewController()
        }, onError: { _ in })
    }
    
    private func loadVolunteerSlidePageViewController() {
        volunteerSlidePageViewController?.configureSlides(index: 0, models: volunteerList)
    }
    
    private func getInternshipData() {
        APICaller.getInstance().getInternshipData(onSuccess: { list in
            self.internshipList = list
            self.loadInternshipSlidePageViewController()
        }, onError: { _ in })
    }
    
    private func loadInternshipSlidePageViewController() {
        internshipSlidePageViewController?.configureSlides(index: 0, models: internshipList)
    }
    
    private func loadVolunteerWebView() {
        let urlRequest = NSURLRequest(url: NSURL(string: "http://breadsdonations.com/volunteer.php")! as URL)
        volunteerWebView.loadRequest(urlRequest as URLRequest)
    }
    
    private func loadInternshipWebView() {
        let urlRequest = NSURLRequest(url: NSURL(string: "http://breadsdonations.com/internship.php")! as URL)
        internshipWebView.loadRequest(urlRequest as URLRequest)
    }
    
    private func animateScrollView(point: CGPoint) {
        scrollView.setContentOffset(point, animated: true)
    }
    
    private func animate(with value: CGFloat) {
        UIView.animate(withDuration: 0.2, animations: {
            self.indicatorViewLeadingConstraint.constant = value
            self.view.layoutIfNeeded()
        })
    }
    
    private func animateIndicatorView(index: CGFloat) {
        let headerButtonWidth = (screenWidth-23)/2
        let indicatorWidth = headerButtonWidth * 0.9
        let indicatorPoint = (((headerButtonWidth - indicatorWidth)/2) + 23) + (headerButtonWidth*index)
        animate(with: indicatorPoint)
    }
    
    // MARK:- IBActions
    @IBAction private func backButton_Tapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func headererButton_Tapped(button: UIButton) {
        animateScrollView(point: CGPoint(x: CGFloat(button.tag) * screenWidth, y: 0))
        animateIndicatorView(index: CGFloat(button.tag))
    }
    
    @IBAction private func swipeGestureRecognizer(gesture: UISwipeGestureRecognizer) {
        let currentXPoint = scrollView.contentOffset.x
        let xPoint = gesture.direction == .left ? currentXPoint+screenWidth : currentXPoint-screenWidth
        guard xPoint >= 0 && xPoint <= screenWidth else { return }
        animateIndicatorView(index: xPoint/screenWidth)
        animateScrollView(point: CGPoint(x: xPoint, y: 0))
    }
}
