//
//  StoreData.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 14/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class AccountData: NSObject {
    
    private var data: [Account] = []
    
    func add(account: Account) {
        data.append(account)
    }
    
    func add(name: String, username: String, email: String, rating: Float) {
        data.append(Account(name: name, username: username, email: email, rating: rating))
    }
    
    func addAt(index: Int, account: Account) {
        data.insert(account, at: index)
    }
    
    func getAt(index: Int) -> Account {
        return data[index]
    }
    
    func deleteAt(index: Int) -> Account {
        return data.remove(at: index)
    }
    
    func total() -> Int {
        return data.count
    }
}
