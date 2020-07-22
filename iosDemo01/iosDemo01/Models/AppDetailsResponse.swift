//
//  AppDetailsResponse.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 22/7/2020.
//

import ObjectMapper

class AppDetailsResponse: Mappable {
    var results: [AppDetails]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        results  <- map["results"]
    }
}

class AppDetails: NSObject, Mappable {
    var averageUserRatingForCurrentVersion: Double?
    var userRatingCountForCurrentVersion: Int?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        averageUserRatingForCurrentVersion <- map["averageUserRatingForCurrentVersion"]
        userRatingCountForCurrentVersion <- map["userRatingCountForCurrentVersion"]
    }
}
