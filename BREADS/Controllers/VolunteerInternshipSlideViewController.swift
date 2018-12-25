//
//  VolunteerInternshipSlideViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 19/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class VolunteerInternshipSlideViewController: UIViewController {

    // MARK:- Variables
    internal var index = 0
    private var volunteerInternship: VolunteerInternship?
    
    // MARK:- IBoutlets
    @IBOutlet private weak var slideTitle: UILabel!
    @IBOutlet private weak var slideImageView: UIImageView!
    @IBOutlet private weak var slideDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slideImageView.downloadImageFrom(link: volunteerInternship?.image ?? "", contentMode: .scaleAspectFit)
        slideTitle.text = volunteerInternship?.title
        slideDescription.text = volunteerInternship?.description
    }
    
    internal func configure(index: Int, volunteerInternship: VolunteerInternship) {
        self.index = index
        self.volunteerInternship = volunteerInternship
    }
}
