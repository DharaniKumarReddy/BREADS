//
//  AnnualReportViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 25/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class AnnualReportNewsLetterViewController: BaseViewController {

    // MARK:- Varibales
    private var reports: [AnnualReport] = []
    private var letters: [NewsLetter] = []
    
    internal var isReports = false
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "DON BOSCO, BREADS"
        navigationBackWithNoText()
        navigationController?.isNavigationBarHidden = false
        isReports ? getAnnualReports() : getNewsLetters()
    }
    
    // MARK:- Private Methods
    private func getAnnualReports() {
        APICaller.getInstance().getAnnualReport(onSuccess: { reports in
            self.reports = reports
            self.tableView.reloadData()
        }, onError: {_ in})
    }
    
    private func getNewsLetters() {
        APICaller.getInstance().getNewsLetter(onSuccess: { letters in
            self.letters = letters
            self.tableView.reloadData()
        }, onError: {_ in})
    }
}

extension AnnualReportNewsLetterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isReports ? reports.count : letters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AnnualNewsLetterTableCell.self)) as? AnnualNewsLetterTableCell
        let image = isReports ? reports[indexPath.row].image : letters[indexPath.row].image
        let title = isReports ? "Annual Report\n" + reports[indexPath.row].year : letters[indexPath.row].name
        cell?.loadData(imageUrl: image, title: title, delegate: self)
        cell?.tag = indexPath.row
        return cell ?? UITableViewCell()
    }
}

extension AnnualReportNewsLetterViewController: PDFViewerDelegate {
    func loadPdf(index: Int) {
        pushWebViewController(urlString: isReports ? reports[index].urlPdf : letters[index].urlPdf)
    }
}

class AnnualNewsLetterTableCell: UITableViewCell {
    
    fileprivate weak var delegate: PDFViewerDelegate?
    
    @IBOutlet private weak var cellImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    fileprivate func loadData(imageUrl: String, title: String, delegate: PDFViewerDelegate?) {
        cellImageView.downloadImageFrom(link: imageUrl, contentMode: .scaleAspectFill)
        titleLabel.text = title
        self.delegate = delegate
    }
    
    @IBAction private func viewButton_Tapped() {
        delegate?.loadPdf(index: tag)
    }
}

protocol PDFViewerDelegate: class {
    func loadPdf(index: Int)
}
