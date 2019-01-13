//
//  ProjectsViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 24/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {

    // MARK:- Variables
    private var projects: [Project] = []
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 230
        tableView.rowHeight = UITableView.automaticDimension
        getProjects()
        title = "PROJECTS"
        navigationBackWithNoText()
        navigationController?.isNavigationBarHidden = false
    }
    
    private func getProjects() {
        APICaller.getInstance().getProjects(onSuccess: { projects in
            self.projects = projects
            self.tableView.reloadData()
        }, onError: {_ in})
    }
}

extension ProjectsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProjectTableCell.self)) as? ProjectTableCell
        cell?.loadProjectData(project: projects[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard.loadProjectDataListViewController()
        controller.project = projects[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

class ProjectTableCell: UITableViewCell {
    // MARK:- IBOutlets
    @IBOutlet private weak var projectTitleLabel: UILabel!
    @IBOutlet private weak var projectImageView: UIImageView!
    
    // MARK:- Data Method
    internal func loadProjectData(project: Project) {
        projectImageView.downloadImageFrom(link: project.image, contentMode: .scaleAspectFill)
        projectTitleLabel.text = project.name
    }
}
