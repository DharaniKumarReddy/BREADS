//
//  OurStrengthsViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 23/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController {

    // MARK:- Variables
    private var photos: [Photo] = []
    private var videos: [Video] = []
    
    private var viewHeight: CGFloat {
        var safeAreaTop: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeAreaTop = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 20) + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        } else {
            safeAreaTop = 20
        }
        return (screenHeight - (safeAreaTop + 44))/2 - 40
    }
    
    // MARK:- IBOutlets
    @IBOutlet private weak var videosCollectionView: UICollectionView!
    @IBOutlet private weak var photosCollectionView: UICollectionView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "DON BOSCO, BREADS"
        navigationBackWithNoText()
        getGalleryPhotos()
        getVideos()
    }
    
    // MARK:- Private Methods
    private func getGalleryPhotos() {
        APICaller.getInstance().getGalleryPhotos(onSuccess: { photos in
            self.photos = photos
            self.photosCollectionView.reloadData()
        }, onError: {_ in})
    }
    
    private func getVideos() {
        APICaller.getInstance().getVideos(onSuccess: { videos in
            self.videos = videos
            self.videosCollectionView.reloadData()
        }, onError: {_ in})
    }
}

extension MediaViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: viewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == photosCollectionView ? photos.count : videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == videosCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VideoCollectionCell.self), for: indexPath) as? VideoCollectionCell
            cell?.loadData(video: videos[indexPath.row])
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionCell.self), for: indexPath) as? PhotoCollectionCell
            cell?.loadData(photo: photos[indexPath.row])
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == photosCollectionView {
            let photosController = UIStoryboard.loadPhotosViewController()
            photosController.photoId = photos[indexPath.row].id
            navigationController?.pushViewController(photosController, animated: true)
        } else {
            var youtubeUrl = URL(string:"youtube://\(videos[indexPath.row].vId)")!
            if UIApplication.shared.canOpenURL(youtubeUrl){
                UIApplication.shared.open(youtubeUrl, options: [:], completionHandler: nil)
            } else{
                youtubeUrl = URL(string:"https://www.youtube.com/watch?v=\(videos[indexPath.row].vId)")!
                UIApplication.shared.open(youtubeUrl, options: [:], completionHandler: nil)
            }
        }
    }
}

class PhotoCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var photoTitleLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    
    fileprivate func loadData(photo: Photo) {
        photoTitleLabel.text = photo.folderName
        photoImageView.downloadImageFrom(link: photo.image, contentMode: .scaleAspectFill)
    }
}

class VideoCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var videoTitleLabel: UILabel!
    @IBOutlet private weak var videoImageView: UIImageView!
    
    fileprivate func loadData(video: Video) {
        videoTitleLabel.text = video.title
        videoImageView.downloadImageFrom(link: "https://img.youtube.com/vi/\(video.vId)/mqdefault.jpg", contentMode: .scaleAspectFill)
    }
}
