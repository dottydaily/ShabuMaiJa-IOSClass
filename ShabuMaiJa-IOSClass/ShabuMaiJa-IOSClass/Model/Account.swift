//
//  Store.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 14/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class Account: NSObject {

    var name: String
    var username: String
    var email: String
    var rating: Float
    
    init(name: String, username: String, email: String, rating: Float) {
        self.name = name
        self.username = username
        self.email = email
        self.rating = rating
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Pornpat Santibuppakul", "Jirayut Pathaveesrisutha", "Kanon Limprapaipong", "Jiratheep Sadakorn",
                         "Thanachai Wongthatsanekorn", "Palathip Wongyeekul", "Pichaiyut Hamasikhuntaga", "Keattisak Teerapongpipat"]
            let usernames = ["dottypurkt", "romeoalpha", "mini", "junielism", "neoxxza", "ongche", "inorin", "robinker"]
            
            let randomIndex = Int(arc4random_uniform(UInt32(names.count)))
//            let randomIndex = Int.random(in: 0..<names.count)
            
            let selectedName = names[randomIndex]
            let selectedUsername = usernames[randomIndex]
            let selectedEmail = selectedUsername + "@gmail.com"
    
            self.init(name: selectedName, username: selectedUsername, email: selectedEmail, rating: 5.0)
        }
        else {
            self.init(name: "AccountDefaultName", username: "AccountDefaultType", email: "AccountDefaultEmail", rating: 0.0)
        }
    }
}
