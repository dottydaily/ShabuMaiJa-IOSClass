//
//  ViewController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by iOS Dev on 9/7/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit
import GooglePlaces

class MainPageController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        
        GMSPlacesClient.shared().autocompleteQuery("Bingsu", bounds: nil, filter: filter) { (results, error) in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            
            for _ in 0 ..< 10 {
                print("SPACE")
            }
            
            print(results)
            
            if let results = results {
                for place in results {
                    print("YEAH")
                    print(place.placeID)
                }
            } else {
                print("ERROR")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

