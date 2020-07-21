//
//  AppIconImageView.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 20/7/2020.
//

import UIKit

class AppIconImageView: UIImageView {
    var isCircle: Bool = false
    
    func setCornerRadius(_isCircle: Bool, cornerRadius: CGFloat? = nil) {
        self.isCircle = _isCircle
        
        if let _cornerRadius = cornerRadius, !isCircle {
            self.layer.cornerRadius = _cornerRadius
        } else {
            self.layer.cornerRadius = self.frame.height / 2
        }
        
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFill
    }
}
