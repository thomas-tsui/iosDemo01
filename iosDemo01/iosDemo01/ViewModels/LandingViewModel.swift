//
//  LandingViewModel.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 22/7/2020.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

protocol LandingViewControllerDelegate: NSObjectProtocol {
    func reloadTable()
    func setTableFinishedLoadData()
}

class LandingViewModel: NSObject {
    var grossingAppArray: [TopFreeAppDetails] = []
    var appDetailsArray: [TopFreeAppDetails] = []
    
    var filteredData: [TopFreeAppDetails] = []
    
    var currentTopAppDataCount: Int = 10
    
    weak var delegate: LandingViewControllerDelegate?
    
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
