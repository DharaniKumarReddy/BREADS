//
//  RoundedViews.swift
//  BREADS
//
//  Created by Dharani Reddy on 19/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        roundViewCorners(self)
    }
}

class YellowGrey1BorderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        yellowBorderView(self, border: 1.0)
    }
}

class YellowBorderLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        yellowBorderView(self, border: 1.0)
    }
}

private func roundViewCorners(_ view: UIView) {
    view.layer.cornerRadius = view.bounds.height / 2
    view.layer.masksToBounds = true
}

func yellowBorderView(_ view: UIView, border: CGFloat) {
    view.layer.borderWidth = border
    view.layer.borderColor = UIColor(displayP3Red: 255/255, green: 222/255, blue: 30/255, alpha: 1.0).cgColor
}
