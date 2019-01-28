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
            , "MinPrice": restaurant.minPrice]
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
    
    func getPlaceByPrice(minPrice: Double, maxPrice: Double, completion:@escaping (_ restaurantlist: [Restaurant]) -> Void) {
        
 
        DispatchQueue.main.async {
            var restaurantList: [Restaurant] = []
            self.ref.child("PlaceList").observeSingleEvent(of: .value) { (snapshot) in
                for child in snapshot.children {
                    let childDataSnapshot = child as! DataSnapshot
                    let values = childDataSnapshot.value as! NSDictionary
                    let selectedPrice = values["MinPrice"] as! Double
                    
                    if minPrice ... maxPrice ~= selectedPrice {
                        let placeId = values["PlaceId"] as! String
                        let name = values["Name"] as! String
                        let latitude = values["Latitude"] as! Double
                        let longtitude = values["Longitude"] as! Double
                        let address = values["Address"] as! String
                        let reviewScore = values["ReviewScore"] as! Float
                        let isOpen = values["isOpen"] as! Bool
                        let iconURL = values["IconURL"] as! String
                        let minPrice = values["MinPrice"] as! Double
                        
                        let restaurant = Restaurant.init(placeId: placeId, name: name, latitude: latitude, longtitude: longtitude, address: address, reviewScore: reviewScore, isOpen: isOpen, iconURL: iconURL, minPrice: minPrice)
                        restaurantList.append(restaurant)
                    
                    }
                }
                completion(restaurantList)
            }
        }
    }
    
    func getLobbyFromHost(HostUserID: String,placeID: String,username: String, status: String, completion:@escaping (_ accountList: [Account]) -> Void) {
    
        var accountList: [Account] = []
        let stringPath : String = "LobbyList/\(placeID)/\(HostUserID)/Participant"
        self.ref.child(stringPath).observeSingleEvent(of: .value) { (snapshot1) in
            for child in snapshot1.children {
                let childDataSnapshot = child as! DataSnapshot
                let values = childDataSnapshot.value as! NSDictionary
                let email = values["Email"] as! String
                self.ref.child("UserList").observeSingleEvent(of: .value){ (snapshot3) in
                    for child in snapshot3.children{
                        let childDataSnapshot3 = child as! DataSnapshot
                        let values3 = childDataSnapshot3.value as! NSDictionary
                        let selectedUsername = values3["Username"] as! String
                        if username == selectedUsername {
                            let nameHost = values3["Name"] as! String
                            let accountHost = Account.init(name: nameHost, username: username, email: "", password: "")
                            accountList.append(accountHost)
                        }
                    }
                    
                }
                self.ref.child("UserList/\(email)").observeSingleEvent(of: .value){(snapshot2) in
                    for child in snapshot2.children{
                        let childDataSnapshot2 = child as! DataSnapshot
                        let values2 = childDataSnapshot2.value as! NSDictionary
                        let name = values2["Name"] as! String
                        let username = values2["Username"] as! String
                        let account = Account.init(name: name, username: username, email: email, password: "")
                        accountList.append(account)
                    }
                }
            }
            completion(accountList)
        }
    }
    
    func getLobbyFromParticipant(HostUserID: String,placeID: String,username: String, status: String, completion:@escaping (_ status: String) -> Void) {
        
        var accountList: [Account] = []
        let stringPath : String = "LobbyList/\(placeID)/\(HostUserID)"
        self.ref.child(stringPath).observeSingleEvent(of: .value) { (snapshot1) in
            for child in snapshot1.children {
                let childDataSnapshot = child as! DataSnapshot
                let values = childDataSnapshot.value as! NSDictionary
                let email = values["Email"] as! String
                self.ref.child("UserList/\(email)").observeSingleEvent(of: .value){(snapshot2) in
                    for child in snapshot2.children{
                        let childDataSnapshot2 = child as! DataSnapshot
                        let values2 = childDataSnapshot2.value as! NSDictionary
                        let name = values2["Name"] as! String
                        let username = values2["Username"] as! String
                        let account = Account.init(name: name, username: username, email: email, password: "")
                        accountList.append(account)
                    }
                }
            }
            completion(accountList)
        }
    }
    
    func getPlaceByCategory(category: String, completion:@escaping (_ restaurantlist: [Restaurant]) -> Void) {
        
        
        DispatchQueue.main.async {
            var restaurantList: [Restaurant] = []
            self.ref.child("PlaceList").observeSingleEvent(of: .value) { (snapshot) in
                for child in snapshot.children {
                    let childDataSnapshot = child as! DataSnapshot
                    let values = childDataSnapshot.value as! NSDictionary
                    if childDataSnapshot.hasChild("Category") {
                        let selectedCategory = values["Category"] as! String
                        
                        if category == selectedCategory {
                            let placeId = values["PlaceId"] as! String
                            let name = values["Name"] as! String
                            let latitude = values["Latitude"] as! Double
                            let longtitude = values["Longitude"] as! Double
                            let address = values["Address"] as! String
                            let reviewScore = values["ReviewScore"] as! Float
                            let isOpen = values["isOpen"] as! Bool
                            let iconURL = values["IconURL"] as! String
                            let minPrice = values["MinPrice"] as! Double
                            
                            
                            let restaurant = Restaurant.init(placeId: placeId, name: name, latitude: latitude, longtitude: longtitude, address: address, reviewScore: reviewScore, isOpen: isOpen, iconURL: iconURL, minPrice: minPrice)
                            restaurantList.append(restaurant)
                            print(restaurantList.count)
                            
                        }
                    }
                    else {
                        continue
                    }
                    
                    
                    
                }
                completion(restaurantList)
            }
        }
    }
    
    
    
    // use for update some change in firebase database
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
