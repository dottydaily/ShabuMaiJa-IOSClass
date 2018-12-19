//
//  Restaurant.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 2/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

class Restaurant: NSObject {
    
    var name: String
    var reviewScore: Float
    var latitude: Double
    var longtitude: Double
    var placeId: String
    var address: String
    var isOpen: Bool
    var iconURL: String
    
    init(place: DataJSON.Place) {
        self.name = place.name!
        self.reviewScore = place.rating
        self.latitude = place.geometry.location.lat!
        self.longtitude = place.geometry.location.lng!
        self.placeId = place.place_id!
        self.address = place.vicinity!
        self.isOpen = (place.opening_hours?.open_now)!
        self.iconURL = (place.icon)!
    }
    
    override init() {
        self.name = "NO DATA"
        self.reviewScore = 0.0
        self.latitude = 0
        self.longtitude = 0
        self.placeId = "NO DATA"
        self.address = "NO DATA"
        self.isOpen = false
        self.iconURL = "NO DATA"
    }
}
