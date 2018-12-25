//
//  VolunteerInternshipPageViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 19/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class VolunteerInternshipPageViewController: UIPageViewController {

    // MARK:- Variables
    private var models: [VolunteerInternship] = []
    private var index = 0
    
    // Mark: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
    }
    
    internal func configureSlides(index:Int, models:[VolunteerInternship]) {
        self.models = models
        self.index = index
        setSlide(animating: false)
        if models.count > 0 {
            _ = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(changeSlide), userInfo: nil, repeats: true)
        }
    }
    
    internal func setSlide(animating:Bool) {
        if models.count > 0 {
            setViewControllers([setSlideViewController(index: index)], direction: .forward, animated: animating, completion: nil)
        }
    }
    
    @objc private func changeSlide() {
        index += 1
        index = index >= models.count ? index - models.count : index
        let slideViewController = setSlideViewController(index: index)
        setViewControllers([slideViewController], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func setSlideViewController(index: NSInteger) -> VolunteerInternshipSlideViewController {
        let slideViewController = UIStoryboard.loadVolunteerInternshipSlideViewController()
        if index > models.count - 1 {
            slideViewController.configure(index: index, volunteerInternship: models[index])
        } else {
            slideViewController.configure(index: index, volunteerInternship: models[index])
        }
        return slideViewController
    }
}

// MARK: UIPageViewControllerDataSource
extension VolunteerInternshipPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let slideViewController = viewController as? VolunteerInternshipSlideViewController else { return nil }
        var index = slideViewController.index
        if (index == NSNotFound) {
            return nil
        }
        if (index <= 0) {
            index += models.count
        }
        index -= 1
        return setSlideViewController(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let slideViewController = viewController as? VolunteerInternshipSlideViewController else { return nil }
        var index = slideViewController.index
        if (index == NSNotFound) {
            return nil
        }
        index += 1
        if (index >= models.count) {
            index -= models.count
        }
        return setSlideViewController(index: index)
    }
}

extension VolunteerInternshipPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        index = (pageViewController.viewControllers?.last as? VolunteerInternshipSlideViewController)?.index ?? index
    }
    
}
