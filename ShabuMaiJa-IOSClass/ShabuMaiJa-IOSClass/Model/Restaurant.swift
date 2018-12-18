//
//  Restaurant.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 2/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

class Restaurant: NSObject {
    
    var name: String
    var reviewScore: Double
    var categoryType: String
    var latitude: Double
    var longtitude: Double
    
    init(name: String, reviewScore: Double, categoryType: String, latitude: Double, longtitude: Double) {
        self.name = name
        self.reviewScore = reviewScore
        self.categoryType = categoryType
        self.latitude = latitude
        self.longtitude = longtitude
    }
}
