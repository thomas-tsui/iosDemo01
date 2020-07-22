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

    // MARK: Set variables for cell identifier for preventing syntax error
    private let recommendHeaderViewIdentifier: String = "recommendHeaderViewIdentifier"
    private let topFreeAppCellIdentifier: String = "topFreeAppCellIdentifier"
    
    private let viewModel = LandingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
        viewModel.delegate = self
        viewModel.getTopGrossingAppList()
        viewModel.getTopFreeAppList(appCount: viewModel.currentTopAppDataCount)
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
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

extension LandingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 204
    }
}

extension LandingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.appDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: Set up TopFreeAppCell as reusable cell type
        guard let topFreeAppCell = tableView.dequeueReusableCell(withIdentifier: topFreeAppCellIdentifier, for: indexPath) as? TopFreeAppCell else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Test Cell: \(indexPath.row)"
            return cell
        }
        
        topFreeAppCell.setIndexText("\(indexPath.row+1)")
        topFreeAppCell.setImageCornerRadius(indexPath.row%2==1)
        
        let imageUrl = viewModel.appDetailsArray[indexPath.row].image?.last?.label ?? ""
        if let url = URL(string: imageUrl) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    topFreeAppCell.setImage(UIImage(data: data) ?? #imageLiteral(resourceName: "demoIcon1"))
                }
            }
        }
        topFreeAppCell.setAppNameLabelText(viewModel.appDetailsArray[indexPath.row].name ?? "")
        topFreeAppCell.setAppTypeLabelText(viewModel.appDetailsArray[indexPath.row].categoryLabel ?? "")
        topFreeAppCell.setRatingNumCountLabelText("\(viewModel.appDetailsArray[indexPath.row].userRatingCountForCurrentVersion ?? 0)")
        topFreeAppCell.setAppRatings(viewModel.appDetailsArray[indexPath.row].averageUserRatingForCurrentVersion?.round(to: 1) ?? 0)
        return topFreeAppCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // MARK: Set up GrossingAppView as header view
        let header = GrossingAppView.fromNib()
        header.setHeaderCellTitle("推介")
        for app in viewModel.grossingAppArray {
            header.addItem(appTitle: app.name ?? "", appTypeTitle: app.categoryLabel ?? "", id: app.id ?? "")
            let imageUrl = app.image?.last?.label ?? ""
            if let url = URL(string: imageUrl), let index = viewModel.grossingAppArray.index(of: app) {
                getData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        header.setImage(UIImage(data: data) ?? #imageLiteral(resourceName: "demoIcon1"), at: index)
                        header.reload()
                    }
                }
            }
        }
        header.reload()
        return header
    }
}

extension LandingViewController: LandingViewControllerDelegate {
    func reloadTable() {
        self.tableView.reloadData()
    }
}
