//
//  UIStringExtension.swift
//  BREADS
//
//  Created by Dharani Reddy on 24/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func downloadImage(completion: @escaping (UIImage) -> ()) {
        URLSession.shared.dataTask(with: NSURL(string:self)! as URL) {
            (data, response, error) in
            if let data = data {
                completion(UIImage(data: data) ?? #imageLiteral(resourceName: "news_bg"))
            } else {
                completion(#imageLiteral(resourceName: "news_bg"))
            }
            }.resume()
    }
}
