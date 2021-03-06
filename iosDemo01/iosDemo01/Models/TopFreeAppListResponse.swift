//
//  TopFreeAppListResponse.swift
//  iosDemo01
//
//  Created by Thomas Tsui on 22/7/2020.
//
// MARK: This is the model of top free apps API response

import ObjectMapper

// MARK: First level of top free apps API JSON response
class TopFreeAppListResponse: Mappable {
    var entry: [TopFreeAppDetails]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        entry  <- map["entry"]
    }
}

// MARK: The Model of each app content
// MARK: Second level of top free apps API JSON response
class TopFreeAppDetails: NSObject, Mappable {
    var name: String?
    var image: [AppImageDetails]?
    var summary: String?
    var categoryLabel: String?
    var artist: String?
    var id: String?
    var averageUserRatingForCurrentVersion: Double?
    var userRatingCountForCurrentVersion: Int?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        name          <- map["im:name->label", delimiter: "->"]
        image         <- map["im:image"]
        summary       <- map["summary->label", delimiter: "->"]
        categoryLabel <- map["category->attributes->label", delimiter: "->"]
        artist        <- map["im:artist->label", delimiter: "->"]
        id            <- map["id->attributes->im:id", delimiter: "->"]
    }
}

// MARK: Model of different size image URL string in JSON response
class AppImageDetails: NSObject, Mappable {
    var label: String?
    var height: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        label  <- map["label"]
        height <- map["attributes->height", delimiter: "->"]
    }
}


