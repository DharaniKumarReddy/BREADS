//
//  PhotosViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 29/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    // MARK:- Varibales
    internal var photoId: String?
    
    private var photos: [UIImage] = []
    private var activityController : UIActivityViewController!
    
    // MARK:- IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollContentView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var scrollViewWidthConstraint: NSLayoutConstraint!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotosList()
        navigationBackWithNoText()
        title = "DON BOSCO, BREADS"
    }
    
    // MARK:- Private Methods
    private func getPhotosList() {
        APICaller.getInstance().getGalleryHomeList(galleryId: photoId ?? "0", onSuccess: { images in
            self.loadImages(images: images)
        }, onError: {_ in})
    }
    
    private func loadImages(images: [GalleryPhoto]) {
        for galleryPhoto in images {
            galleryPhoto.images.downloadImage(completion: { image in
                image.accessibilityIdentifier = galleryPhoto.id
                self.photos.append(image)
                if self.photos.count == images.count {
                    DispatchQueue.main.async {
                        self.loadScrollImages()
                    }
                }
            })
        }
    }
    
    private func loadScrollImages() {
        scrollViewWidthConstraint.constant = CGFloat(photos.count) * screenWidth
        for (index, photo) in photos.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: screenWidth*CGFloat(index), y: 0, width: screenWidth, height: scrollContentView.bounds.height))
            imageView.image = photo
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            scrollContentView.addSubview(imageView)
        }
        collectionView.reloadData()
    }
    
    override func popViewController() {
        if scrollView.isHidden {
            super.popViewController()
        } else {
            scrollView.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    private func loadActivityController(id: String) {
        let url = URL(string: "http://breadsdonations.com/galleryshare.php?id=\(id)")!
        activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityController.excludedActivityTypes = [.print, .copyToPasteboard, .assignToContact, .saveToCameraRoll, .addToReadingList]
    }
    
    // MARK:- IBActions
    @IBAction private func swipeGesture_Swiped(gesture: UISwipeGestureRecognizer) {
        let currentXPoint = scrollView.contentOffset.x
        let xPoint = gesture.direction == .left ? currentXPoint+screenWidth : currentXPoint-screenWidth
        guard xPoint >= 0 && xPoint <= (screenWidth * CGFloat(photos.count-1)) else { return }
        scrollView.setContentOffset(CGPoint(x: xPoint, y: 0), animated: true)
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/2, height: screenWidth/2 - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoListCollectionCell.self), for: indexPath) as? PhotoListCollectionCell
        cell?.photoImageView.image = photos[indexPath.row]
        cell?.delegate = self
        cell?.tag = indexPath.row
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollView.setContentOffset(CGPoint(x: screenWidth*CGFloat(indexPath.row), y: 0), animated: false)
        scrollView.isHidden = false
        collectionView.isHidden = true
    }
}

extension PhotosViewController: ShareDelegate {
    func share(id: Int) {
        loadActivityController(id: photos[id].accessibilityIdentifier ?? "")
        present(activityController, animated: true, completion: nil)
    }
}

class PhotoListCollectionCell: UICollectionViewCell {
    fileprivate var delegate: ShareDelegate?
    @IBOutlet fileprivate var photoImageView: UIImageView!
    @IBAction private func shareButton_Tapped() {
        delegate?.share(id: tag)
    }
}
