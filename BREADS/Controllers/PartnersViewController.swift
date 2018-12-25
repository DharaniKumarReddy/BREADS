//
//  PartnersViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 24/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class PartnersViewController: UIViewController {

    private var partners: [Partner] = []
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "DON BOSCO, BREADS"
        getPartners()
        navigationBackWithNoText()
    }
    
    private func getPartners() {
        APICaller.getInstance().getPartners(onSuccess: { partners in
            self.partners = partners
            self.getPartnerImages()
        }, onError: {_ in})
    }
    
    private func getPartnerImages() {
        var partnerImages: [UIImage] = []
        for partner in partners {
            partner.logo.downloadImage(completion: { image in
                partnerImages.append(image)
                if partnerImages.count == self.partners.count {
                    DispatchQueue.main.async {
                        self.animateImageSlides(images: partnerImages)
                    }
                }
            })
        }
    }
    
    private func animateImageSlides(images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = TimeInterval(images.count * 2)
        imageView.startAnimating()
    }
}
