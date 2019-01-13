//
//  NewsDetailedViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 12/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class NewsDetailedViewController: UIViewController {

    internal var news: NewsModel?
    private var activityController : UIActivityViewController!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        navigationBackWithNoText()
        title = "DON BOSCO, BREADS"
        loadActivityController(id: news?.id ?? "")
    }
    
    private func loadActivityController(id: String) {
        let url = URL(string: "http://breadsdonations.com/newshare.php?id=\(id)")!
        activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityController.excludedActivityTypes = [.print, .copyToPasteboard, .assignToContact, .saveToCameraRoll, .addToReadingList]
    }
}

extension NewsDetailedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsDetailedTableCell.self)) as? NewsDetailedTableCell
        cell?.loadNewsInfo(newsInfo: news)
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
}

extension NewsDetailedViewController: ShareDelegate {
    func share(id: Int) {
        present(activityController, animated: true, completion: nil)
    }
}

class NewsDetailedTableCell: UITableViewCell {
    fileprivate var delegate: ShareDelegate?
    // MARK:- IBOutlets
    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsDescriptionLabel: UILabel!
    @IBOutlet private weak var newsDateLabel: UILabel!
    
    // MARK:- Private Methods
    fileprivate func loadNewsInfo(newsInfo: NewsModel?) {
        let descriptionHeight = newsInfo?.description.heightWithConstrainedWidth(width: screenWidth-40, font: UIFont(name: "HoeflerText-Regular", size: 16)!) ?? 16
        let titleHeight = newsInfo?.title.heightWithConstrainedWidth(width: screenWidth-40, font: UIFont(name: "HoeflerText-Regular", size: 21)!) ?? 23
        addShadow(height: descriptionHeight+titleHeight)
        newsImageView.image = #imageLiteral(resourceName: "news_bg")
        newsImageView.downloadImageFrom(link: newsInfo?.image ?? "", contentMode: .scaleAspectFill)
        newsTitleLabel.text = newsInfo?.title
        newsDescriptionLabel.text = newsInfo?.description
        newsDateLabel.text = newsInfo?.date
    }
    
    private func addShadow(height: CGFloat) {
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: screenWidth-24, height: height+314))
        borderView.layer.masksToBounds = false
        borderView.layer.shadowColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0).cgColor
        borderView.layer.shadowOffset = CGSize(width: 0, height: 0)
        borderView.layer.shadowOpacity = 0.9
        borderView.layer.shadowPath = shadowPath.cgPath
    }
    
    @IBAction private func shareButton_Tapped() {
        delegate?.share(id: tag)
    }
}
