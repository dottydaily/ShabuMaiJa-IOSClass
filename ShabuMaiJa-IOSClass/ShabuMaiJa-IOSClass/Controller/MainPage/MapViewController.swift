//
//  MapViewController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by RomeoAlpha on 11/23/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import UIKit
import MapKit
import GooglePlacePicker
import GooglePlaces

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var completer: MKLocalSearchCompleter!
    var resultArray: [MKLocalSearchCompletion]!
    
    // The code snippet below shows how to create GMSPlacePickerViewController.
//    var placePickerConfig: GMSPlacePickerConfig!
//    var placePickerController: GMSPlacePickerViewController!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Make trackingButton for tracking your current location
        let trackingButton = MKUserTrackingButton(mapView: self.mapView)
        
//        // Time : Will delete this (May be)
//        // Need this to allow auto layout (If true all constrains that we add just won't matter
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.addSubview(trackingButton)
        self.mapView.addConstraints([
            trackingButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -10),
            trackingButton.rightAnchor.constraint(equalTo: self.mapView.rightAnchor, constant: -10)])
//
        self.mapView.userTrackingMode = .follow
    }
    
    @IBAction func backToMapPage(seg: UIStoryboardSegue) {
        
    }

    // for sending some data to next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // check if segue is a ChooseActionView
        // Because this view have subview (GMSPlacePickerViewController)
        // There is chance that segue will be this one instead.
        if (segue.destination is ChooseActionController) {
            let controller = segue.destination as! ChooseActionController
            
            // use for pop up back to previous view controller
            // because we can go to ChooseActionView by multiple ways
            controller.previousViewController = self
        }
    }
    
    @IBAction func searchButtonAction() {
        let request = MKLocalSearchRequest()
//        request.region = mapView.region
        request.region = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!, 500, 500)
        request.naturalLanguageQuery = "Shabu"
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (response, error) in
            guard let response = response else {
                print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
                return
            }
            
            for item in response.mapItems {
                print(item.name)
                let ann = MKPointAnnotation()
                ann.coordinate = item.placemark.coordinate
                ann.title = item.name
                self.mapView.addAnnotation(ann)
            }
        }
//        completer = MKLocalSearchCompleter()
//        completer.delegate = self
////        completer.region = mapView.region
//        completer.region = MKCoordinateRegionMakeWithDistance(mapView.centerCoordinate, 10, 10)
//        //        completer.region = MKCoordinateRegionForMapRect(mapView.visibleMapRect)
//        //        completer.region = MKCoordinateRegionMakeWithDistance(mapView.region.center, 500, 500)
//        print(completer.region.center)
//        completer.queryFragment = "Kuma Shabu"
    }
}

//extension MapViewController: MKLocalSearchCompleterDelegate {
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        resultArray = completer.results
//
//        for completion in resultArray {
//            print("COMPLETION : \(completion.title)")
//            let request = MKLocalSearchRequest(completion: completion)
////            request.region = mapView.region
//
//            let localSearch = MKLocalSearch(request: request)
//            localSearch.start { (response, error) in
//                guard let response = response else {
//                    print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
//                    return
//                }
//
//                for item in response.mapItems {
//                    print(item.name)
//                    let ann = MKPointAnnotation()
//                    ann.coordinate = item.placemark.coordinate
//                    ann.title = item.name
//                    self.mapView.addAnnotation(ann)
//                }
//            }
//        }
//    }
//
//    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        print("Error finding naja")
//    }
//}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location: \(location)")
            
//            let span = MKCoordinateSpanMake(0.005, 0.005)
//            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR")
    }
}
