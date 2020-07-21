//
//  GrossingAppViewCell.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 21/7/2020.
//
// MARK: This is UICollectionViewCell for displaying grossing app data

import UIKit

class GrossingAppViewCell: UICollectionViewCell {
    @IBOutlet var imageView: AppIconImageView!
    @IBOutlet var appTitle: UILabel!
    @IBOutlet var appType: UILabel!
    
    public var id: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initLayout()
    }
    
    private func initLayout() {
        // MARK: Default round corner radius
        imageView.setCornerRadius(_isCircle: false, cornerRadius: 12)
        
        appTitle.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        appTitle.textColor = UIColor.black
        
        appType.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        appType.textColor = UIColor.gray
    }
    
    // MARK: Providing public functions for ViewController to assign data
    func setImage(_ image: UIImage?) {
        self.imageView.image = image
    }
    
    func setAppTitle(_ name: String) {
        self.appTitle.text = name
    }
    
    func setAppTypeLabel(_ name: String) {
        self.appType.text = name
    }
    
    func setAppId(_ id: Int) {
        self.id = id
    }
}
