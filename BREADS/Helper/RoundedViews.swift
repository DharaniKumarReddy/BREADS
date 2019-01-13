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

class DynamicLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "HoeflerText-Regular", size: getFontSize())
    }
}

class DynamicButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = UIFont(name: "HoeflerText-Regular", size: getFontSize())
    }
}

func getFontSize() -> CGFloat {
    return iPhoneSE ? 17 : iPhoneStandard ? 19 : 21
}
