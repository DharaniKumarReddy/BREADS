//
//  ProjectDataListViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 24/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class ProjectDataListViewController: UIViewController {
    
    // MARK:- Variables
    private var projectDataList: [ProjectData] = []
    
    internal var project: Project?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = project?.name
        navigationBackWithNoText()
        getProjectData()
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK:- Private Methods
    private func getProjectData() {
        APICaller.getInstance().getProjectList(projectId: project?.id, onSuccess: { projectList in
            self.projectDataList = projectList
            self.tableView.reloadData()
        }, onError: { _ in })
    }
}

extension ProjectDataListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProjectDataTableCell.self)) as? ProjectDataTableCell
        cell?.loadProjectData(project: projectDataList[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

class ProjectDataTableCell: UITableViewCell {
    // MARK:- IBOutlets
    @IBOutlet private weak var projectDateLabel: UILabel!
    @IBOutlet private weak var projectTitleLabel: UILabel!
    @IBOutlet private weak var projectDescriptionLabel: UILabel!
    @IBOutlet private weak var projectImageView: UIImageView!
    
    // MARK:- Data Method
    internal func loadProjectData(project: ProjectData) {
        projectImageView.downloadImageFrom(link: project.image, contentMode: .scaleAspectFill)
        projectTitleLabel.text = project.title
        projectDescriptionLabel.text = project.description
        projectDateLabel.text = project.date
    }
    
}
