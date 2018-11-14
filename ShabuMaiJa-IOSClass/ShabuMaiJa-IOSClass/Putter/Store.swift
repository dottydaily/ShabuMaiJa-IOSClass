//
//  Store.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 14/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class Store: NSObject {

    var name: String
    var type: String
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Kuma Shabu", "Terrace", "After You"]
            let types = ["Shabu", "Grilled", "Dessert Cafe"]
            
            let randomIndex = Int.random(in: 0..<names.count)
            
            self.init(name: names[randomIndex], type: types[randomIndex])
        }
        else {
            self.init(name: "StoreDefaultName", type: "StoreDefaultType")
        }
    }
}
