//
//  UIView+Extension.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 21/7/2020.
//

import UIKit

extension UIView {
    public class func fromNib(nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil: nibNameOrNil, type: self)
    }
    
    public class func fromNib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        if let nibViews = Bundle(for: type).loadNibNamed(name, owner: nil, options: nil) {
            for v in nibViews {
                if let tog = v as? T {
                    view = tog
                }
            }
        }
        return view ?? T()
    }
    
    public class var nibName: String {
        let name = "\(self)".components(separatedBy: ".").first ?? ""
        return name
    }
}

extension UICollectionReusableView {
    public class func fromNib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: String(describing: self), bundle: bundle)
    }
}

extension UITableViewCell {
    public class func fromNib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: String(describing: self), bundle: bundle)
    }
}
