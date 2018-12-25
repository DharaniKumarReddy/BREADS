//
//  UIImageViewExtensions.swift
//  BREADS
//
//  Created by Dharani Reddy on 13/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        if image == nil {
            image = #imageLiteral(resourceName: "news_bg")
        }
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    self.image = UIImage(data: data)
                } else {
                    self.image = #imageLiteral(resourceName: "news_bg")
                }
            }
        }).resume()
    }
}
