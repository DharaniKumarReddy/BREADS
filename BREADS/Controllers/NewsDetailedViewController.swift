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
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        navigationBackWithNoText()
        title = "DON BOSCO, BREADS"
    }
}

extension NewsDetailedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsDetailedTableCell.self)) as? NewsDetailedTableCell
        cell?.loadNewsInfo(newsInfo: news)
        return cell ?? UITableViewCell()
    }
}

class NewsDetailedTableCell: UITableViewCell {
    // MARK:- IBOutlets
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsDescriptionLabel: UILabel!
    @IBOutlet private weak var newsDateLabel: UILabel!
    
    // MARK:- Private Methods
    fileprivate func loadNewsInfo(newsInfo: NewsModel?) {
        newsImageView.image = #imageLiteral(resourceName: "news_bg")
        newsImageView.downloadImageFrom(link: newsInfo?.image ?? "", contentMode: .scaleAspectFill)
        newsTitleLabel.text = newsInfo?.title
        newsDescriptionLabel.text = newsInfo?.description
        newsDateLabel.text = newsInfo?.date
    }
}
