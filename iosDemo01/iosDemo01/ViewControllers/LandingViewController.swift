//
//  LandingViewController.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 19/7/2020.
//

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private let recommendHeaderViewIdentifier: String = "recommendHeaderViewIdentifier"
    private let topFreeAppCellIdentifier: String = "topFreeAppCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TopFreeAppCell.fromNib(), forCellReuseIdentifier: topFreeAppCellIdentifier)
    }
}

extension LandingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 204
    }
}

extension LandingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let topFreeAppCell = tableView.dequeueReusableCell(withIdentifier: topFreeAppCellIdentifier, for: indexPath) as? TopFreeAppCell else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Test Cell: \(indexPath.row)"
            return cell
        }
        topFreeAppCell.setIndexText("\(indexPath.row+1)")
        topFreeAppCell.setImage(#imageLiteral(resourceName: "demoIcon1"))
        topFreeAppCell.setImageCornerRadius(indexPath.row%2==1)
        topFreeAppCell.setAppNameLabelText("APP APP APP")
        topFreeAppCell.setAppTypeLabelText("Game")
        topFreeAppCell.setRatingNumCountLabelText("17")
        topFreeAppCell.setAppRatings(2.5)
        return topFreeAppCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = GrossingAppView.fromNib()
        header.setHeaderCellTitle("推介")
        for index in 0..<10 {
            header.addItem(appTitle: "APP APP APP APP APP", appTypeTitle: "Game", id: index)
        }
        header.reload()
        return header
    }
}
