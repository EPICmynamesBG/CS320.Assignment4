//
//  RoundedButton.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/19/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let roundedCorners: UIRectCorner = .AllCorners
        let cornerRadius: CGSize = CGSizeMake(10, 10)
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundedCorners, cornerRadii: cornerRadius)
        let maskLayer:CAShapeLayer = CAShapeLayer(layer: self.layer)
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
}
