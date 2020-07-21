//
//  GrossingAppView.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 21/7/2020.
//
// MARK: This is header view with grossing app collection view in Landing page

import UIKit

class GrossingAppView: UIView {
    // MARK: Model of grossing app content
    struct recommendItem {
        var image: UIImage = #imageLiteral(resourceName: "demoIcon1")
        let appTitle: String
        let appTypeTitle: String
        let id: Int
        
        init(appTitle: String, appTypeTitle: String, id: Int) {
            self.appTitle = appTitle
            self.appTypeTitle = appTypeTitle
            self.id = id
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Set variables for cell identifier for preventing syntax error
    private let appCellIdentifier = "RecommendAppViewCell"
    public var items: [recommendItem] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(GrossingAppViewCell.fromNib(), forCellWithReuseIdentifier: appCellIdentifier)
        collectionView.reloadData()
    }
    
    private func initLayout() {
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    // MARK: Providing public functions for ViewController to assign data
    func setHeaderCellTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    func addItem(appTitle: String, appTypeTitle: String, id: Int) {
        let item = recommendItem(appTitle: appTitle, appTypeTitle: appTypeTitle, id: id)
        items.append(item)
    }
    
    func setImage(_ image: UIImage, at index: Int) {
        guard index < items.count else { return }
        items[index].image = image
    }
    
    func clearItems() {
        items = []
    }
    
    func reload() {
        collectionView.reloadData()
    }
}

extension GrossingAppView: UICollectionViewDelegate {
    
}

extension GrossingAppView: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // MARK: Set up GrossingAppViewCell as reusable cell type & set data to the cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appCellIdentifier, for: indexPath) as? GrossingAppViewCell {
            if indexPath.row < items.count {
                let item = items[indexPath.row]
                cell.setImage(item.image)
                cell.setAppTitle(item.appTitle)
                cell.setAppTypeLabel(item.appTypeTitle)
                cell.setAppId(item.id)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
