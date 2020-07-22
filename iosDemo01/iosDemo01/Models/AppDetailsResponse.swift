//
//  AppDetailsResponse.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 22/7/2020.
//
// MARK: This is the model of look up apps API response

import ObjectMapper

// MARK: First level of look up apps API JSON response
class AppDetailsResponse: Mappable {
    var results: [AppDetails]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        results  <- map["results"]
    }
}

// MARK: Second level of look up apps API JSON response
// MARK: Picked up rating related keys only
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
