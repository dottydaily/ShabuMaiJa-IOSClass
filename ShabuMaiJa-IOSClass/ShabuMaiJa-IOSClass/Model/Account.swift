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
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Pornpat Santibuppakul", "Jirayut Pathaveesrisutha", "Kanon Limprapaipong", "Jiratheep Sadakorn",
                         "Thanachai Wongthatsanekorn", "Palathip Wongyeekul", "Pichaiyut Hamasikhuntaga", "Keattisak Teerapongpipat"]
            let usernames = ["dottypurkt", "romeoalpha", "mini", "junielism", "neoxxza", "ongche", "inorin", "robinker"]
            
            let randomIndex = Int(arc4random_uniform(UInt32(names.count)))
//            let randomIndex = Int.random(in: 0..<names.count)
            
            self.init(name: names[randomIndex], username: usernames[randomIndex])
        }
        else {
            self.init(name: "AccountDefaultName", username: "AccountDefaultType")
        }
    }
}
