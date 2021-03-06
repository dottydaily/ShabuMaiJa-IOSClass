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
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    var choosedRestaurant: Restaurant? = nil
    var ourPlaceAnnotations: [MKRestaurantAnnotation] = []
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
//        database.emergencyMethod()  // use for random minPrice and Category (use if needed)
        
        /////////////////////////////////////////////////////
        // Do any additional setup after loading the view. //
        /////////////////////////////////////////////////////
        
        // set up constraint for choosed place 'button'
        self.bottomButtonConstraint.constant = -100
        button.layer.cornerRadius = 25
        
        // set delegate to this view
        searchBar.delegate = self   // to manage what to do with search bar
        mapView.delegate = self     // to manage what to do with annotation on mapview
        
        // request and get current location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // implements in extension, forcing keyboard to hide itself when tap outside of it
        self.hideKeyboardWhenTappedAround()
        
        // Make trackingButton for tracking your current location
        let trackingButton = MKUserTrackingButton(mapView: self.mapView)
        
        // Need this to allow auto layout (If true all constrains that we add just won't matter
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.addSubview(trackingButton)
        self.mapView.addConstraints([
            trackingButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -10),
            trackingButton.rightAnchor.constraint(equalTo: self.mapView.rightAnchor, constant: -10)])
        self.mapView.userTrackingMode = .follow
    }
    
    // for mannaul unwind segue
    @IBAction func backToMapPage(seg: UIStoryboardSegue) {
        
    }

    // handle choose place action button
    @IBAction func choosePlace(_ sender: Any) {
        performSegue(withIdentifier: "goToCreateFindPage", sender: self)
    }
    
    // for setup some data to next ChooseActionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ChooseActionController
        
        // send this view controller to ChooseActionView for its manual unwind segue
        // because we can go to ChooseActionView by multiple ways
        controller.previousViewController = self
        controller.choosedRestaurant = choosedRestaurant
        
        }
    }

extension MapViewController: CLLocationManagerDelegate {
    
    // to confirm that we will get this location for sure.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.requestLocation()
    }
    
    // make mapview follow device's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location: \(location)")
            
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 5000, 5000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // handle error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR GET LOCATION")
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // for make all of annotation appear (if not use this, some will be hidden when zoom out)
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // need to do
        // check if annotation is MKRestaurantAnnotation
        
        if annotation is MKRestaurantAnnotation {
            let reuseIdentifier = "annotationView"
            var ann = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            if ann == nil {
                ann = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            }
            
            ann?.displayPriority = .required
            ann?.annotation = annotation
            ann?.canShowCallout = true
            
            return ann
        } else {
            return nil
        }
    }
    
    // handle action when select
    func mapView(_ mapView: MKMapView, didSelect ann: MKAnnotationView) {
        if let annTitle = ann.annotation!.title {
            if annTitle != "My Location" {
                button.setTitle("Choose \"\(annTitle!)\"", for: .normal)
                
                // debugging log
                print("User selected an annotation's title:\(annTitle)")
                
                // pop the choose button up
                UIView.animate(withDuration: 0.5) {
                    self.button.alpha = 1
                    self.bottomButtonConstraint.constant = 20
                    self.view.layoutIfNeeded()  // force view to update its layout
                }
            
                let annPoint = ann.annotation as! MKRestaurantAnnotation
                choosedRestaurant = annPoint.restaurantDetail
                
                print(choosedRestaurant)
            
            }
        }
    }
    
    // handle action when deselect
    func mapView(_ mapView: MKMapView, didDeselect ann: MKAnnotationView) {
        
        // push the choose button down
        UIView.animate(withDuration: 0.5) {
            self.button.alpha = 0
            self.bottomButtonConstraint.constant = -100
            self.view.layoutIfNeeded()  // force view to update its layout
        }
        
        choosedRestaurant = nil
    }
}

extension MapViewController: UISearchBarDelegate {
    
    // use this to send req to google places api, and get JSON data, convert it into DataJSON Object
    // add @escaping by xcode, still don't know what it is
    // use this function to prevent some case that code below task.resume() is running before getting all of result of request
    func getJSON(reqURL url:URL, completion: @escaping (_ data: DataJSON?)-> Void) {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            do {
                let dataGetByJSON = try JSONDecoder().decode(DataJSON.self, from: data)
                completion(dataGetByJSON)
            } catch let jsonError {
                print("Error parsing : \(jsonError)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    // handle action when submit search by search bar
    func searchFromSearchBarText(inputText text:String){
        if(text == "" ){
            sendAlertUtil(Title: "Invalid Input", Description: "Please enter " )
        }else{
            ourPlaceAnnotations = []
            let lat = String(locationManager.location!.coordinate.latitude)
            let long = String(locationManager.location!.coordinate.longitude)
            let searchText = text.replacingOccurrences(of: " ", with: "_")
            var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=1800&language=th&type=restaurant&keyword=\(searchText)&key=\(apiKey!)"

//            let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=5000&language=th&type=restaurant&keyword="

            // need to do
            // url.appendPathComponent(ภาษาไทย)
            
            // debugging log
            print(lat)
            print(long)
            print(searchText)
            print(apiKey)
            print(urlString)
            
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            
            var url = URL(string: urlString)!
            
            print(url.absoluteString)
//
           
            getJSON(reqURL: url) { (data) in
                let sv = self.displaySpinner(onView: self.view, alpha: 0.6)
                if let data = data {
                    for place in data.results! {
                        let restaurant = Restaurant(place: place!)
                        
                        print("&&&&&&&& This restaurant is : " + restaurant.name)
                        print("--------")
                        print("Place name --> "+place!.name!)
                        
                        let ann = MKRestaurantAnnotation()
                        ann.coordinate.latitude = (place?.geometry.location.lat)!
                        ann.coordinate.longitude = (place?.geometry.location.lng)!
                        ann.title = place?.name
                        ann.placeId = (place?.place_id)!
                        ann.restaurantDetail = restaurant
                        
                        print("Annotation name --> "+ann.title!)
                        print("Object RestaurantDetail name --> "+ann.restaurantDetail.name)
                        
                        
                        self.mapView.addAnnotation(ann)
                        self.ourPlaceAnnotations.append(ann)
                    }
                    if self.ourPlaceAnnotations.count == data.results!.count {
                        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                        self.removeSpinner(spinner: sv)
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            print("\(self.ourPlaceAnnotations.count) , \(data.results!.count)")
                            if self.ourPlaceAnnotations.count == data.results!.count {
                                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                                self.removeSpinner(spinner: sv)
                            }else{
                                self.removeSpinner(spinner: sv)
                                self.sendAlertUtil(Title: "Cant Load", Description: "Check Connection")
                            }
                        })
                    }
                    
                }
                if data!.results?.count == 0{
                    self.removeSpinner(spinner: sv)
                    self.sendAlertUtil(Title: "Error", Description: "No Place Found")
                }
                
                print("######## CHECIKING OUR PLACE ANNOTATIONS #######")
                for balloon in self.ourPlaceAnnotations {
                    print("ourPlaceAnnotations : " + balloon.restaurantDetail.name)
                }
                
            }
        }
    }
    
    // remove all previous annotations when searching new place
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            removeAllAnnotations()
            searchFromSearchBarText(inputText: searchBar.text!)
            self.dismissKeyboard()
        }
    }
    
    // remove all annotations
    func removeAllAnnotations(){
        let allAnns = self.mapView.annotations
        self.mapView.removeAnnotations(allAnns)
    }
}

