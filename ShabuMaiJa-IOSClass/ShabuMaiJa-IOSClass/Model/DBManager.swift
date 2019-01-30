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
    
    func createUser(user: Account, completion: @escaping (_ user: Account?)->Void) {
        ref.child("UserList/\(user.username)").setValue(["Name":user.name, "Username":user.username, "Email":user.email, "Rating":user.rating])
        
        completion(user)
    }
    func getUserListFromLobby(HostUserID: String,placeID: String,status: String, completion:@escaping (_ accountList: [Account]) -> Void) {
    
        var accountList: [Account] = []
        let stringPath : String = "LobbyList/\(placeID)/\(HostUserID)/Participant"
        self.ref.child("UserList/\(HostUserID)").observeSingleEvent(of: .value){ (snapshot3) in // get info of host
                let childDataSnapshot3 = snapshot3
                let values3 = childDataSnapshot3.value as! NSDictionary
                let nameHost = values3["Name"] as! String
                let emailHost = values3["Email"] as! String
            let accountHost = Account.init(name: nameHost, username: HostUserID, email: emailHost, rating: 5.0)
                accountList.append(accountHost)
            
        }
        self.ref.child(stringPath).observeSingleEvent(of: .value) { (snapshot1) in
            for child in snapshot1.children {
                let childDataSnapshot = child as! DataSnapshot
                let username = childDataSnapshot.key
                self.ref.child("UserList/\(username)").observeSingleEvent(of: .value){(snapshot2) in // get info of all participant
                        let childDataSnapshot2 = snapshot2
                        let values2 = childDataSnapshot2.value as! NSDictionary
                        let name = values2["Name"] as! String
                        let email = values2["Email"] as! String
                    let account = Account.init(name: name, username: username, email: email, rating: 5.0)
                        accountList.append(account)
                }
            }
            completion(accountList)
        }
    }
    
    func checkStatusFromLobby(HostUserID: String,placeID: String,status: String, completion:@escaping (_ currentS: String) -> Void) {
        
        var currentS: String = ""
        let stringPath : String = "LobbyList/\(placeID)/\(HostUserID)/Status"
        self.ref.child(stringPath).observe(.value, with: {(snapshot) in
            currentS = snapshot.value as! String
           
        })
         completion(currentS)
      }
//    func getLobbyFromParticipant(placeID: String,username: String, status: String, completion:@escaping (_ accountList: [Account]) -> Void) {
//        var accountList: [Account] = []
//        let stringPath : String = "LobbyList/\(placeID)"
//        self.ref.child(stringPath).observeSingleEvent(of: .value) { (snapshot1) in
//            for child in snapshot1.children {
//                let childDataSnapshot = child as! DataSnapshot
//                let hostUsername = childDataSnapshot.key // get host username
//                let values = childDataSnapshot.value as! NSDictionary
//                self.ref.child("LobbyList/\(placeID)/\(hostUsername)/Participant").observeSingleEvent(of: .value) { (snapshot3) in
//                    for child in snapshot3.children{
//                        let childDataSnapshot3 = child as! DataSnapshot
//                        let participantUsername = childDataSnapshot3.key
////                        let values3 = childDataSnapshot3.value as! NSDictionary
//                        if participantUsername == username{  // check username of participant that in lobby or not
//                            self.ref.child("UserList/").observeSingleEvent(of: .value){ (snapshot4) in
//                                for child in snapshot4.children{
//                                    let childDataSnapshot4 = child as! DataSnapshot
//                                    let usernameHost = childDataSnapshot4.key
//                                    if usernameHost == hostUsername {
//                                        let nameHost = values3["Name"] as! String
//                                        let emailHost = values3["Email"] as! String
//                                        let accountHost = Account.init(name: nameHost, username: usernameHost, email: emailHost, password: "")
//                                        accountList.append(accountHost)
//                                    }
//                                }
//
//                            }
//                            self.ref.child("LobbyList/\(placeID)/\(hostUsername)/Participant").observeSingleEvent(of: .value) { (snapshot2) in
//                                for child in snapshot2.children {
//                                    let childDataSnapshot2 = child as! DataSnapshot
//                                    let username = childDataSnapshot2.key
//                                    self.ref.child("UserList/\(username)").observeSingleEvent(of: .value){(snapshot4) in // get info of all participant
//                                        let childDataSnapshot4 = snapshot4
//                                        let values4 = childDataSnapshot4.value as! NSDictionary
//                                        let name = values4["Name"] as! String
//                                        let email = values4["Email"] as! String
//                                        let account = Account.init(name: name, username: username, email: email, password: "")
//                                        accountList.append(account)
//                                    }
//                                }
//                            }
//                }
//            completion(accountList)
//        }
//    }
//
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
