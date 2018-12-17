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

class MapViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    
    // The code snippet below shows how to create GMSPlacePickerViewController.
    var placePickerConfig: GMSPlacePickerConfig!
    var placePickerController: GMSPlacePickerViewController!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let trackingButton = MKUserTrackingButton(mapView: self.mapView)
//
//        // Time : Will delete this (May be)
//        // Need this to allow auto layout (If true all constrains that we add just won't matter
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.addSubview(trackingButton)
////        self.mapView.addConstraints([
////            trackingButton.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor),
////            trackingButton.centerYAnchor.constraint(equalTo: self.mapView.centerYAnchor)])
        self.mapView.addConstraints([
            trackingButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -10),
            trackingButton.rightAnchor.constraint(equalTo: self.mapView.rightAnchor, constant: -10)])
//
        self.mapView.userTrackingMode = .follow
        
        // Place Picker instantiation
//        self.placePickerConfig = GMSPlacePickerConfig(viewport: nil)
//        self.placePickerController = GMSPlacePickerViewController(config: placePickerConfig)
//        placePickerController.delegate = self
//        placePickerController.modalPresentationStyle = .fullScreen
        
        // manipulate subview
//        addChildViewController(placePickerController)
//        view.addSubview(placePickerController.view)
//        placePickerController.didMove(toParentViewController: self)
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Restaurant"
        request.region = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 1, longitudeDelta: 1))

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
//    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
//
//        print("Place name \(place.name)")
//        print("Place address \(place.formattedAddress)")
//        print("Place attributions \(place.attributions)")
//
//        self.performSegue(withIdentifier: "goToCreateFindPage", sender: self)
//    }
    
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
}
