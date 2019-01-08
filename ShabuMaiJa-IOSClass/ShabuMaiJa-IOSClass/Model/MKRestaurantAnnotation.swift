//
//  MKRestaurantAnnotation.swift
//  ShabuMaiJa-IOSClass
//
//  Created by RomeoAlpha on 12/24/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import Foundation
import MapKit

class MKRestaurantAnnotation: MKPointAnnotation {
    var restaurantDetail: Restaurant
    var placeId: String
    
    override init() {
        restaurantDetail = Restaurant()
        placeId = "Unknown"
    }
}
