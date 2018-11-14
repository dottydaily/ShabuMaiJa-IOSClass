//
//  StoreData.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 14/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class StoreData: NSObject {
    
    private var data: [Store] = []
    
    func add(store: Store) {
        data.append(store)
    }
    
    func add(storeName: String, storeType: String) {
        data.append(Store(name: storeName, type: storeType))
    }
    
    func addAt(index: Int, store: Store) {
        data.insert(store, at: index)
    }
    
    func getAt(index: Int) -> Store {
        return data[index]
    }
    
    func deleteAt(index: Int) -> Store {
        return data.remove(at: index)
    }
    
    func total() -> Int {
        return data.count
    }
}
