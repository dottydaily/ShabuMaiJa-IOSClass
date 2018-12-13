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

class MapViewController: UIViewController , GMSPlacePickerViewControllerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    // The code snippet below shows how to create GMSPlacePickerViewController.
    var placePickerConfig: GMSPlacePickerConfig!
    var placePicker: GMSPlacePickerViewController!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        let trackingButton = MKUserTrackingButton(mapView: self.mapView)
//
//        // Time : Will delete this (May be)
//        // Need this to allow auto layout (If true all constrains that we add just won't matter
//        trackingButton.translatesAutoresizingMaskIntoConstraints = false
//        self.mapView.addSubview(trackingButton)
////        self.mapView.addConstraints([
////            trackingButton.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor),
////            trackingButton.centerYAnchor.constraint(equalTo: self.mapView.centerYAnchor)])
//        self.mapView.addConstraints([
//            trackingButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -10),
//            trackingButton.rightAnchor.constraint(equalTo: self.mapView.rightAnchor, constant: -10)])
//
//        self.mapView.userTrackingMode = .follow
        
        // Place Picker instantiation
        self.placePickerConfig = GMSPlacePickerConfig(viewport: nil)
        self.placePicker = GMSPlacePickerViewController(config: placePickerConfig)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let auth = CLLocationManager.authorizationStatus()
        
        switch auth {
        case .denied, .notDetermined, .restricted : // for any case that can't get location
            let alert = UIAlertController(title: "Cannot access location", message: "Please allow", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        default:
            break
        }
    }

    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "goToCreateFindPage", sender: self)
        })
        
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
    @IBAction func goToSelectMode(_ sender: Any) {
        performSegue(withIdentifier: "goToSelectSearch", sender: self)
    }
    
    @IBAction func backToMapPage(seg: UIStoryboardSegue) {
        
    }

}
