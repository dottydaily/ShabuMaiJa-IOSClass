//
//  DBManager.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Palatip Wongyeekul on 19/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DBManager {
    fileprivate var database: Database!
    fileprivate var ref: DatabaseReference
    
    init() {
        database = Database.database()
        ref = database.reference()
    }
    
    func hasPlace(placeId: String) -> Bool {
        var hasIt: Bool = false
        
        ref.child("PlaceIdList").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(placeId) {
                hasIt = true
            }
        }) { (error) in
            print(error)
        }
        
        return hasIt
    }
    
    func addPlace(restaurant: Restaurant) -> DatabaseReference {
        let nodeAtPlaceListID = ref.child("PlaceIdList").childByAutoId()
        nodeAtPlaceListID.setValue(["Id": restaurant.placeId])
        
        let nodeAtPlaceList = ref.child("PlaceList").child(restaurant.placeId)
        nodeAtPlaceList.setValue(
            ["PlaceId": restaurant.placeId, "Name": restaurant.name
            , "Latitude": restaurant.latitude, "Longitude": restaurant.longtitude
            , "Address": restaurant.address, "ReviewScore": restaurant.reviewScore
            , "isOpen": restaurant.isOpen, "IconURL": restaurant.iconURL
            , "MinPrice": restaurant.minPrice, "MaxPrice": restaurant.maxPrice]
        )
        
        return nodeAtPlaceList
    }
    
    func updatePlace(restaurant: Restaurant, completion: (_ placeRef: DatabaseReference) -> Void) {
        let placeRef: DatabaseReference
        
        if !hasPlace(placeId: restaurant.placeId) {
            placeRef = addPlace(restaurant: restaurant)
        }
        else {
            placeRef = self.ref.child("PlaceList").child(restaurant.placeId)
        }
        
        completion(placeRef)
    }
    
    func getMinPrice(restaurant: Restaurant) -> Double {
        var returnValue = 0.0
        
        DispatchQueue.main.async {
            self.ref.child("\(restaurant.placeId)/MinPrice").observeSingleEvent(of: .value) { (minPrice) in
                returnValue = (minPrice.value as? Double)!
            }
        }
        
        return returnValue
    }
    
    func getMaxPrice(restaurant: Restaurant) -> Double {
        var returnValue = 0.0
        
        DispatchQueue.main.async {
            self.ref.child("\(restaurant.placeId)/MinPrice").observeSingleEvent(of: .value) { (maxPrice) in
                returnValue = (maxPrice.value as? Double)!
            }
        }
        
        return returnValue
    }
    
    func getPlaceByPrice(minPrice: Double, maxPrice: Double) -> [Restaurant] {
        var restaurantList: [Restaurant] = []
        ref.child("PlaceList").observeSingleEvent(of: .value) { (snapshot) in
            let places = snapshot.value as! NSDictionary
            
//            for place in places {
//                if place["MinPrice"] {
//
//                }
//            }
        }
        
        return restaurantList
    }
    
    func emergencyMethod() {
        ref.child("PlaceList").observeSingleEvent(of: .value) { (snapshot) in
            for item in snapshot.children {
                var child = item as! DataSnapshot
                print(child.ref)
                child.ref.updateChildValues(["MinPrice" : Int.random(in: 100 ..< 700)])
            }
        }
    }
}
