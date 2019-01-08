//
//  ChooseActionController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Pornpat Santibuppakul on 12/13/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import UIKit
import GooglePlaces

class ChooseActionController: UIViewController {
    
    var previousViewController: UIViewController! = nil
    var choosedRestaurant: Restaurant! = nil
    @IBOutlet weak var restaurantPicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        database.updatePlace(restaurant: choosedRestaurant) { (restaurantRef) in
        }
        
        print("Start loading image from url")
        
        DispatchQueue.main.async {
            GMSPlacesClient.shared().lookUpPhotos(forPlaceID: self.choosedRestaurant.placeId) { (photos, err) in
                if let err = err {
                    print("can't get image from this place")
                } else {
                    if let firstPhoto = photos?.results.first {
                        GMSPlacesClient.shared().loadPlacePhoto(firstPhoto, callback: { (photo, err) in
                            if let err = err {
                                print("already get image but can't load it")
                            } else {
                                self.restaurantPicture.contentMode = .scaleToFill
                                self.restaurantPicture.image = photo
                            }
                        })
                    } else {
                        self.restaurantPicture.image = #imageLiteral(resourceName: "warning")
                    }
                }
            }
        }
        
        nameLabel.text = choosedRestaurant.name
        ratingLabel.text = String(choosedRestaurant.reviewScore)
        addressLabel.text = choosedRestaurant.address
    }
    
    @IBAction func unwindToPrevious(_ sender: Any) {
        navigationController?.popToViewController(previousViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var controller = segue.destination
        
        if controller is CreateGroupController {
            // do something
        } else { // is FindGroupController
            // do something
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
