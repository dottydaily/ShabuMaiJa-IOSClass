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
    
    func deleteDataAtPath(path: String) {
        print("Removing \(path)")
        ref.child(path).removeValue()
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
                , "MinPrice": restaurant.minPrice, "Category": restaurant.category]
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
        ref.child("UserList/\(user.uid)").setValue(["Name":user.name, "Username":user.username, "Email":user.email, "Rating":user.rating])
        
        completion(user)
    }
    
    func getUser(uid: String, completion: @escaping (_ user: Account?)->Void) {
        ref.child("UserList/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
            let datas = snapshot.value as! NSDictionary
            let name = datas["Name"] as! String
            let username = datas["Username"] as! String
            let email = datas["Email"] as! String
            let rating = datas["Rating"] as! Float
            
            let user = Account(name: name, username: username, uid: uid, email: email, rating: rating)
            
            completion(user)
        }
    }
    
    func createLobby(restaurant: Restaurant, host: Account, maxPeople: Int, description: String, completion: @escaping ()->Void) {
        ref.child("LobbyList/\(restaurant.placeId)/\(host.uid)").setValue([
            "Status" : "Waiting", "CurrentPeople" : 1, "TotalPeople" : maxPeople,
            "Description" : description, "Participant" : ["1" : host.uid], "Restaurant Name" : restaurant.name])
        completion()
    }
    
    func updateStatus(status: String,lobby: Lobby)->Void{
        ref.child("LobbyList/\(lobby.placeId)/\(lobby.hostId)/Status").setValue(status)
    }
    
    // getting lobby list of specific restaurant
    // result is accountList that each people is host of each lobby
    func getLobbyList(placeId: String,completion: @escaping(_ accountList: [Account])->Void){
        var accountList : [Account] = []
        
        ref.child("LobbyList/\(placeId)").observe(.value) {(snapshot) in
            if snapshot.exists() {
                let totalChild = snapshot.childrenCount
                var i = 0
                
                // child is each lobby of this restaurant
                for child in snapshot.children{
                    let childDataSnapshot = child as! DataSnapshot
                    i += 1
                    
                    let uid = childDataSnapshot.key
                    print(uid)
                    let status = childDataSnapshot.childSnapshot(forPath: "Status").value as! String
                    
                    if status == "Waiting" {
                        self.getUser(uid: uid, completion: { (user) in
                            print(user?.name)
                            accountList.append(user!)
                            
                            if i == totalChild {
                                completion(accountList)
                            }
                        })
                    } else {
                        completion(accountList)
                    }
                }
            } else {
                completion(accountList)
            }
        }
        
    }
    func getLobby(placeId:String,hostId:String,completion: @escaping(_ lobby: Lobby)->Void){
        
        print("LobbyList/\(placeId)/\(hostId)")
        ref.child("LobbyList/\(placeId)/\(hostId)").observeSingleEvent(of: .value){(snapshot) in
            let value = snapshot.value as! NSDictionary
            let currentPeople = value["CurrentPeople"] as! Int
            let totalPeople = value["TotalPeople"] as! Int
            let description = value["Description"] as! String
            let status = value["Status"] as! String
            
            let desLobby = Lobby(currentPeople: currentPeople, totalPeople: totalPeople, description: description, status: status, hostId: hostId, placeId: placeId)
            completion(desLobby)
        }
    }
    func addParticipantLobby(placeId:String,hostId:String,userId:String, completion: @escaping (_ isError: Bool)->Void){
        let path = "LobbyList/\(placeId)/\(hostId)"
        ref.child(path).observeSingleEvent(of: .value){(snapshot) in
            let value = snapshot.value as! NSDictionary
            let currentPeople = value["CurrentPeople"] as! Int
            let totalPeople = value["TotalPeople"] as! Int
            if currentPeople+1 <= totalPeople {
                
                self.ref.child(path+"/Participant").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild(userId) {
                        completion(true)
                    } else {
                        self.ref.child(path+"/Participant/\(currentPeople+1)").setValue(userId)
                        self.ref.child(path+"/CurrentPeople").setValue(currentPeople+1)
                        completion(false)
                    }
                })
            } else {
                completion(true)
            }
        }
    }
    
    func removeParticipant(placeId: String, hostId: String, userId: String, completion: @escaping (_ isError: Bool, _ currentPeople: Int)->Void) {
        
        // check if has this room, then delete specific participant
        ref.child("LobbyList/\(placeId)/\(hostId)/Participant").observe(.value) { (snapshot) in
            if snapshot.exists() {
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    let checkedID = childSnapshot.value as! String
                    if userId == checkedID {
                        self.deleteDataAtPath(path: "LobbyList/\(placeId)/\(hostId)/Participant/\(childSnapshot.key)")
                    }
                    break
                }
                
                // update CurrentPeople Count
                self.ref.child("LobbyList/\(placeId)/\(hostId)/CurrentPeople").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let currentPeople = snapshot.value as! Int
                    
                    if snapshot.key != nil {
                        self.ref.child("LobbyList/\(placeId)/\(hostId)/CurrentPeople").setValue(currentPeople-1)
                        completion(false, currentPeople-1)
                    } else {
                        completion(true, currentPeople)
                    }
                })
            }
            else {
                completion(true, 0)
            }
        }
    }
    
    func getUserListFromLobby(placeID: String, hostID: String, completion: @escaping (_ accounts: AccountData)->Void) {
        ref.child("LobbyList/\(placeID)/\(hostID)/Participant").observe(.value) { (snapshot) in
            
            let total = snapshot.childrenCount
            var i = 0
            var userList = AccountData()
            
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                let userID = dataSnapshot.value as! String
                print("\(i) : userID = \(userID)")
                i += 1
                
                self.getUser(uid: userID, completion: { (user) in
                    userList.add(account: user!)
                    
                    if i == total {
                        completion(userList)
                    }
                })
            }
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
                
                let randomNumber = Int.random(in: 100 ..< 700)
                let categoryList = ["Shabu", "Yakiniku", "FastFood", "Dessert"]
                child.ref.updateChildValues(["MinPrice" : randomNumber])
                child.ref.child("Category").setValue(categoryList[randomNumber%4])
            }
        }
    }
}
