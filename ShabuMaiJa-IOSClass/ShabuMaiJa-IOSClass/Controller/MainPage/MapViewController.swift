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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var popUpSubView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    var locationManager: CLLocationManager!
    var completer: MKLocalSearchCompleter!
    var resultArray: [MKLocalSearchCompletion]!
    var searchActive: Bool = false
    var popUpSubVC: PlaceDetailSubViewController!
    
    // The code snippet below shows how to create GMSPlacePickerViewController.
//    var placePickerConfig: GMSPlacePickerConfig!
//    var placePickerController: GMSPlacePickerViewController!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.bottomButtonConstraint.constant = -100
        button.layer.cornerRadius = 25
        
        searchBar.delegate = self
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        self.hideKeyboardWhenTappedAround()
        
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

    @IBAction func choosePlace(_ sender: Any) {
        performSegue(withIdentifier: "goToCreateFindPage", sender: self)
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
        request.region = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!, 5000, 5000)
        request.naturalLanguageQuery = "Shabu"
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (response, error) in
            guard let response = response else {
                print("There was an error searching for: \(request.naturalLanguageQuery) error: \(String(describing: error))")
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
    
    //remove all annotations
    func removeAllAnnotation(){
        let allAnns = self.mapView.annotations
        self.mapView.removeAnnotations(allAnns)
    }
}

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
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "annotationView"
        var ann = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if ann == nil {
            ann = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        
        ann?.displayPriority = .required
        ann?.annotation = annotation
        ann?.canShowCallout = true
        return ann
    }
    
    func mapView(_ mapView: MKMapView, didSelect ann: MKAnnotationView) {
        if let annTitle = ann.annotation!.title {
            button.setTitle("Choose \"\(annTitle!)\"", for: .normal)
            print("User selected an annotation's title:\(annTitle)")
        }
        
        UIView.animate(withDuration: 0.5) {
            self.button.alpha = 1
            self.bottomButtonConstraint.constant = 20
            self.view.layoutIfNeeded()
        }
//        popUpSubVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpSubVC") as! PlaceDetailSubViewController
//
//        addChildViewController(popUpSubVC)
//        view.addSubview(popUpSubVC.view)
//        popUpSubVC.didMove(toParentViewController: self)
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect ann: MKAnnotationView) {
        
        UIView.animate(withDuration: 0.5) {
            self.button.alpha = 0
            self.bottomButtonConstraint.constant = -100
            self.view.layoutIfNeeded()
        }
    }
}

extension MapViewController: UISearchBarDelegate {
    
    func searchFromSearchBarText(inputText text:String){
        let request = MKLocalSearchRequest()
        //        request.region = mapView.region
        request.region = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!, 5000, 5000)
        request.naturalLanguageQuery = text
        
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                if searchBar.text != nil {
                    self.removeAllAnnotation()
                    searchFromSearchBarText(inputText: searchBar.text!)
                }
    
    }

}


// use this anywhere you want to hide keyboard (self.hideKeyboardWhenTappedAround)
extension UIViewController{
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
}
