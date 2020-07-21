//
//  TopFreeAppCell.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 21/7/2020.
//
// MARK: This is UITableViewCell for displaying top free app data

import UIKit
import Cosmos

class TopFreeAppCell: UITableViewCell {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var appIconImageView: AppIconImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appTypeLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingNumCountLabel: UILabel!
    
    // MARK: lazy init rating star view and added after ratingView parent view is ready
    private lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        view.settings.starSize = 12
        view.settings.starMargin = 0.5
        view.settings.fillMode = .half
        view.settings.updateOnTouch = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initLayout()
    }
    
    private func initLayout() {
        self.selectionStyle = .none
        indexLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        indexLabel.textColor = UIColor.gray
        appNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        appNameLabel.textColor = UIColor.black
        appTypeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        appTypeLabel.textColor = UIColor.gray
        ratingNumCountLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        ratingNumCountLabel.textColor = UIColor.gray
        
        ratingView.backgroundColor = .white
        cosmosView.frame = ratingView.bounds
        ratingView.addSubview(cosmosView)
    }
    
    // MARK: Providing public functions for ViewController to assign data
    func setIndexText(_ indexText: String) {
        indexLabel.text = indexText
    }
    
    func setImage(_ image: UIImage) {
        appIconImageView.image = image
    }
    
    func setImageCornerRadius(_ isCircle: Bool) {
        appIconImageView.setCornerRadius(_isCircle: isCircle, cornerRadius: isCircle ? nil : 12)
    }
    
    func setAppNameLabelText(_ appName: String) {
        appNameLabel.text = appName
    }
    
    func setAppTypeLabelText(_ appType: String) {
        appTypeLabel.text = appType
    }
    
    func setRatingNumCountLabelText(_ ratingNum: String) {
        ratingNumCountLabel.text = "(\(ratingNum))"
    }
    
    func setAppRatings(_ ratings: Double) {
        cosmosView.rating = ratings
    }
}
