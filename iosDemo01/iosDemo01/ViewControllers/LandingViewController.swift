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
    
    // MARK: Init LandingViewModel instance
    private let viewModel = LandingViewModel()
    
    // MARK: Flags for controlling tableview
    private var isLoadingData = false
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
        setUpViewTapGesture()
        
        searchBar.delegate = self
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
    
    // MARK: Set up view tap gesture to allow user dismiss keyboard by tapping blank area
    private func setUpViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TopFreeAppCell.fromNib(), forCellReuseIdentifier: topFreeAppCellIdentifier)
    }
    
    // MARK: Functions for picture downloading
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

extension LandingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isSearching ? 0.1 : 204
    }
    
    // MARK: Trigger paging function when user scroll to the bottom of tableview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            let distanceFromBottom = scrollView.contentSize.height - scrollView.contentOffset.y
            if distanceFromBottom <= scrollView.frame.size.height {
                guard viewModel.currentTopAppDataCount < 100, !isLoadingData, !isSearching else { return }
                isLoadingData = true
                viewModel.currentTopAppDataCount += 10
                viewModel.getTopFreeAppList(appCount: viewModel.currentTopAppDataCount)
            }
        }
    }
}

extension LandingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching ? viewModel.filteredData.count : viewModel.appDetailsArray.count
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
        
        // MARK: Conditions with taking data source
        let appDetail: TopFreeAppDetails = isSearching ? viewModel.filteredData[indexPath.row] : viewModel.appDetailsArray[indexPath.row]
        
        // MARK: Download image from URL
        let imageUrl = appDetail.image?.last?.label ?? ""
        if let url = URL(string: imageUrl) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    topFreeAppCell.setImage(UIImage(data: data) ?? #imageLiteral(resourceName: "demoIcon1"))
                }
            }
        }
        
        // MARK: Set contents to top free app cell
        topFreeAppCell.setAppNameLabelText(appDetail.name ?? "")
        topFreeAppCell.setAppTypeLabelText(appDetail.categoryLabel ?? "")
        topFreeAppCell.setRatingNumCountLabelText("\(appDetail.userRatingCountForCurrentVersion ?? 0)")
        topFreeAppCell.setAppRatings(appDetail.averageUserRatingForCurrentVersion?.round(to: 1) ?? 0)
        return topFreeAppCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // MARK: If user is searching, hide header view
        guard !isSearching else { return nil }
        
        // MARK: Set up GrossingAppView as header view
        let header = GrossingAppView.fromNib()
        header.setHeaderCellTitle("推介")
        for app in viewModel.grossingAppArray {
            // MARK: Set contents to collection view cell
            header.addItem(appTitle: app.name ?? "", appTypeTitle: app.categoryLabel ?? "", id: app.id ?? "")
            
            // MARK: Download image from URL
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
    
    func setTableFinishedLoadData() {
        self.isLoadingData = false
    }
}

extension LandingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchText)
    }
    
    // MARK: Searching in grossing app list and top free app list
    func filterContentForSearchText(searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            isSearching = true
            var filteredTopAppData: [TopFreeAppDetails] = []
            var filteredGrossingAppData:  [TopFreeAppDetails] = []
            
            filteredTopAppData = viewModel.appDetailsArray.filter { TopFreeAppDetails in
                guard let name = TopFreeAppDetails.name,
                      let summary = TopFreeAppDetails.summary,
                      let categoryLabel = TopFreeAppDetails.categoryLabel,
                      let artist = TopFreeAppDetails.artist else { return false }
                return name.lowercased().contains(searchText.lowercased()) ||
                       summary.lowercased().contains(searchText.lowercased()) ||
                       categoryLabel.lowercased().contains(searchText.lowercased()) ||
                       artist.lowercased().contains(searchText.lowercased())
            }
            
            filteredGrossingAppData = viewModel.grossingAppArray.filter { TopFreeAppDetails in
                guard let name = TopFreeAppDetails.name,
                      let summary = TopFreeAppDetails.summary,
                      let categoryLabel = TopFreeAppDetails.categoryLabel,
                      let artist = TopFreeAppDetails.artist else { return false }
                return name.lowercased().contains(searchText.lowercased()) ||
                       summary.lowercased().contains(searchText.lowercased()) ||
                       categoryLabel.lowercased().contains(searchText.lowercased()) ||
                       artist.lowercased().contains(searchText.lowercased())
            }
            
            viewModel.filteredData = filteredTopAppData + filteredGrossingAppData
            self.tableView.reloadData()
        } else {
            viewModel.filteredData = []
            isSearching = false
            self.tableView.reloadData()
        }
    }
}
