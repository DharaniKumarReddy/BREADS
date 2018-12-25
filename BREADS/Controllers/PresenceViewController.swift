//
//  PresenceViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 24/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class PresenceViewController: BaseViewController {

    private let relatedSites = ["www.dbbangalore.org", "www.donboscoyadgiri.org", "www.fcdpindia.org", "www.donbosco.ac.in", "www.donboscobidar.com", "www.dbsnehabhavan.org", "www.boscoban.org", "www.dbclm.org"]
    // MARK:- IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK:- Private Methods
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
        let headerButtonWidth = (screenWidth-30)/2
        let indicatorWidth = headerButtonWidth * 0.9
        let indicatorPoint = (((headerButtonWidth - indicatorWidth)/2) + 30) + (headerButtonWidth*index)
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

extension PresenceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedSites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RelatedSitesTableCell.self)) as? RelatedSitesTableCell
        cell?.relatedSiteNameLabel.text = relatedSites[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushWebViewController(urlString: relatedSites[indexPath.row])
    }
}

class RelatedSitesTableCell: UITableViewCell {
    @IBOutlet fileprivate weak var relatedSiteNameLabel: UILabel!
}
