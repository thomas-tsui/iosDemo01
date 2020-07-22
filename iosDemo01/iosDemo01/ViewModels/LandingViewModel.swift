//
//  LandingViewModel.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 22/7/2020.
//
// MARK: This is landing page view model for providing API functions and data processing

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

// MARK: Protocol for commuicating with LandingVC
protocol LandingViewControllerDelegate: NSObjectProtocol {
    func reloadTable()
    func setTableFinishedLoadData()
}

class LandingViewModel: NSObject {
    // MARK: Grossing App data
    var grossingAppArray: [TopFreeAppDetails] = []
    
    // MARK: Top Free App data
    var appDetailsArray: [TopFreeAppDetails] = []
    
    // MARK: Search results data
    var filteredData: [TopFreeAppDetails] = []
    
    var currentTopAppDataCount: Int = 10
    
    weak var delegate: LandingViewControllerDelegate?
    
    // MARK: API function for getting grossing app list
    func getTopGrossingAppList(appCount:Int = 10) {
        let URL = "https://itunes.apple.com/hk/rss/topgrossingapplications/limit=\(appCount)/json"
        Alamofire.request(URL).responseObject(keyPath: "feed") { (response: DataResponse<TopFreeAppListResponse>) in
            switch response.result {
            case .success:
                guard let _response = response.result.value, let entry = _response.entry else {
                    print("Error")
                    return
                }
                self.grossingAppArray = entry
                
                // MARK: API function for looking up app details and getting star ratings
                if entry.count > 0 {
                    let combinedIdString = self.getAppsId(array: entry)
                    let appsDetailURL = "https://itunes.apple.com/hk/lookup?id=\(combinedIdString)"
                    Alamofire.request(appsDetailURL).responseObject { (response: DataResponse<AppDetailsResponse>) in
                        switch response.result {
                        case .success:
                            guard let _response = response.result.value, let results = _response.results else {
                                print("Error")
                                return
                            }
                            for (index, value) in results.enumerated() {
                                self.grossingAppArray[index].averageUserRatingForCurrentVersion = value.averageUserRatingForCurrentVersion
                                self.grossingAppArray[index].userRatingCountForCurrentVersion = value.userRatingCountForCurrentVersion
                            }
                            self.delegate?.reloadTable()
                        case .failure:
                            print("Error")
                        }
                    }
                }
                self.delegate?.reloadTable()
            case .failure:
                print("Error")
            }
        }
    }
    
    // MARK: API function for getting Top Free app list
    func getTopFreeAppList(appCount:Int = 10) {
        let appListURL = "https://itunes.apple.com/hk/rss/topfreeapplications/limit=\(appCount)/json"
        Alamofire.request(appListURL).responseObject(keyPath: "feed") { (response: DataResponse<TopFreeAppListResponse>) in
            switch response.result {
            case .success:
                guard let _response = response.result.value, let entry = _response.entry else {
                    print("Error")
                    return
                }
                self.appDetailsArray = entry
                
                // MARK: API function for looking up app details and getting star ratings
                if entry.count > 0 {
                    let combinedIdString = self.getAppsId(array: entry)
                    let appsDetailURL = "https://itunes.apple.com/hk/lookup?id=\(combinedIdString)"
                    Alamofire.request(appsDetailURL).responseObject { (response: DataResponse<AppDetailsResponse>) in
                        switch response.result {
                        case .success:
                            guard let _response = response.result.value, let results = _response.results else {
                                print("Error")
                                return
                            }
                            for (index, value) in results.enumerated() {
                                self.appDetailsArray[index].averageUserRatingForCurrentVersion = value.averageUserRatingForCurrentVersion
                                self.appDetailsArray[index].userRatingCountForCurrentVersion = value.userRatingCountForCurrentVersion
                            }
                            self.delegate?.reloadTable()
                            self.delegate?.setTableFinishedLoadData()
                        case .failure:
                            print("Error")
                        }
                    }
                }
                
                self.delegate?.reloadTable()
            case .failure:
                print("Error")
            }
        }
    }
    
    // MARK: combined app id to a string for further API call
    func getAppsId(array: [TopFreeAppDetails]) -> String {
        var combinedIdString = ""
        for item in array {
            guard let _id = item.id else { continue }
            combinedIdString += _id + ","
        }
        return combinedIdString
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
