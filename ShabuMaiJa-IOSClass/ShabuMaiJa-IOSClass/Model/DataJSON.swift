//
//  DataJSON.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 19/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import Foundation

class DataJSON: Decodable {
    struct Place: Decodable {
        struct Geometry: Decodable {
            struct Location: Decodable {
                var lat: Double?
                var lng: Double?
            }
            
            struct Viewport: Decodable {
                var northeast: Location
                var southwest: Location
            }
            
            var location: Location
            var viewport: Viewport
        }
        
        struct OpeningHours: Decodable {
            var open_now: Bool
        }
    
        struct Photo: Decodable {
            var height: Int
            var html_attributions: [String?]
            var photo_reference: String?
            var width: Int
        }
        
        struct PlusCode: Decodable {
            var compound_code: String
            var global_code: String
        }
        
        var geometry: Geometry
        var icon: String?
        var id: String
        var name: String?
        var opening_hours: OpeningHours?
        var photos: [Photo?]?
        var place_id: String?
        var plus_code: PlusCode?
        var rating: Float
        var reference: String
        var scope: String
        var types: [String?]
        var vicinity: String?
    }
    
    init() {
        html_attributions = []
        results = []
        status = "empty"
    }
    
    func printResults() {
        for result in results {
            print("place id : \(result?.place_id!)")
            print("place name : \(result?.name!)")
            print("place address : \(result?.vicinity!)")
        }
    }
    
    var html_attributions: [String?]
    var results: [Place?]
    var status: String
}
