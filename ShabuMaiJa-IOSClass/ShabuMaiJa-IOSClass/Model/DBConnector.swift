//
//  DBConnector.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Palatip Wongyeekul on 19/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DBConnector {
    var database: Database!
    var ref: DatabaseReference
    
    init() {
        database = Database.database()
        ref = database.reference()
    }
    
    func hasPlace(placeId: String) -> Bool {
        var hasIt: Bool = false
        
        ref.child("PlaceIdList").observeSingleEvent(of: .value, with: { (data) in
            let valueList = data.value as? NSDictionary
            
            for _ in valueList! {
                let currentPlaceId = valueList?["PlaceId"] as? String ?? ""
                
                if currentPlaceId == placeId {
                    hasIt = true
                }
            }
        }) { (error) in
            print(error)
        }
        
        return hasIt
    }
    
    func addPlace(restaurant: Restaurant) {
        let nodeAtPlaceListID = ref.child("PlaceIdList").childByAutoId()
        nodeAtPlaceListID.setValue(["Id": restaurant.placeId])
        
        let nodeAtPlaceList = ref.child("PlaceList").child(restaurant.placeId)
        nodeAtPlaceList.setValue(["PlaceId": restaurant.placeId, "Name": restaurant.name, "Latitude": restaurant.latitude, "Longitude": restaurant.longtitude, "Address": restaurant.address, "ReviewScore": restaurant.reviewScore, "isOpen": restaurant.isOpen, "IconURL": restaurant.iconURL])
    }
}
