//
//  Restaurant.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 2/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

class Restaurant: NSObject {
    
    var placeId: String
    var name: String
    var latitude: Double
    var longtitude: Double
    var address: String
    var reviewScore: Float
    var isOpen: Bool
    var iconURL: String
    var minPrice: Double
    var hostUsername: String?
    var category: String
    
    init(place: DataJSON.Place) {
        self.name = place.name!
        self.reviewScore = place.rating
        self.latitude = place.geometry.location.lat!
        self.longtitude = place.geometry.location.lng!
        self.placeId = place.place_id!
        self.address = place.vicinity!
        if place.opening_hours != nil && place.opening_hours?.open_now != nil{
            self.isOpen = (place.opening_hours?.open_now)!
        } else {
            self.isOpen = false
        }
        
        self.iconURL = (place.icon)!
        
        self.minPrice = Double(Int.random(in: 100..<700))
        self.hostUsername = nil
        
        let categoryList = ["Shabu", "Yakiniku", "FastFood", "Dessert"]
        self.category = categoryList[Int.random(in: 0...3)]
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
        self.hostUsername = "NO DATA"
        self.category = "NO DATA"
        
        self.minPrice = 0
    }
    
    init(placeId: String, name: String, latitude: Double, longtitude: Double, address: String, reviewScore: Float, isOpen: Bool, iconURL: String, minPrice: Double) {
        
        self.placeId = placeId
        self.name = name
        self.latitude = latitude
        self.longtitude = longtitude
        self.address = address
        self.reviewScore = reviewScore
        self.isOpen = isOpen
        self.iconURL = iconURL
        self.minPrice = minPrice
        
        let categoryList = ["Shabu", "Yakiniku", "FastFood", "Dessert"]
        self.category = categoryList[Int.random(in: 0...3)]
    }
    
    override var description: String {
        return "placeId : \(placeId)\nname : \(name)\nminPrice : \(minPrice)"
    }
}
