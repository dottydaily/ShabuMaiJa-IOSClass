//
//  MapViewController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by RomeoAlpha on 11/23/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let trackingButton = MKUserTrackingButton(mapView: self.mapView)
        
        // Time : Will delete this (May be)
        // Need this to allow auto layout (If true all constrains that we add just won't matter
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.addSubview(trackingButton)
        self.mapView.addConstraints([
        trackingButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: 0),
        trackingButton.rightAnchor.constraint(equalTo: self.mapView.rightAnchor, constant: 0)])
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
    //Time : Follow user button will make it always follow user.Cannot turn off following unless disable location service.
    @IBAction func followUserSwitchValueChange(_ sender: UISwitch) {
        // sender is Switch in UI
        if (sender.isOn) {
            self.mapView.userTrackingMode = .follow
        }
        else {
            self.mapView.userTrackingMode = .none
        }
    }

    @IBAction func goToSelectMode(_ sender: Any) {
        performSegue(withIdentifier: "goToSelectSearch", sender: self)
    }
    
    @IBAction func backToMapPage(seg: UIStoryboardSegue) {
        
    }

}
