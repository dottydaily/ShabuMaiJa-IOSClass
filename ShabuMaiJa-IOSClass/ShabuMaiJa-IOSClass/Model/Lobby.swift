//
//  Lobby.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Pornpat Santibuppakul on 1/30/19.
//  Copyright © 2019 iOS Dev. All rights reserved.
//

import UIKit

class Lobby: NSObject {
    var currentPeople: Int
    var lobbyDescription: String
    var totalPeople: Int
    var status: String
    var hostId: String
    var placeId: String
    
    init(currentPeople:Int,totalPeople:Int,description:String,status:String,hostId:String,placeId:String){
        self.currentPeople = currentPeople
        self.totalPeople = totalPeople
        self.lobbyDescription = description
        self.status = status
        self.hostId = hostId
        self.placeId = placeId
    }

}
