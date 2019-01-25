//
//  ChooseActionController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Pornpat Santibuppakul on 12/13/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import UIKit
import GooglePlaces
import FirebaseAuth

class ChooseActionController: UIViewController {
    
    var previousViewController: UIViewController! = nil
    var choosedRestaurant: Restaurant! = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UITextView!
    
    var imageArr : [UIImage] = []
    var handle: AuthStateDidChangeListenerHandle? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        database.updatePlace(restaurant: choosedRestaurant) { (restaurantRef) in
        }
        
        print("Start loading image from url")
        
        DispatchQueue.main.async {
            self.downloadImages()
        }
        
        // One cell at a single time
        collectionView.isPagingEnabled = true
        
        let sv = displaySpinner(onView: self.view, alpha: 1)
        
        
        //Waiting for image then reload collection view data
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            for image in self.imageArr{
                print(image)
            }
            self.collectionView.reloadData()
            self.removeSpinner(spinner: sv)
        }
        
        nameLabel.text = choosedRestaurant.name
        ratingLabel.text = String(choosedRestaurant.reviewScore)
        addressLabel.text = choosedRestaurant.address
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    
    @IBAction func handleCreateButton(_ sender: Any) {
        print("\n\nPREPARING BEFORE GO TO CREATE GROUP")
        if Auth.auth().currentUser == nil {
            print("nil need to login")
            // create subview that let user signin or signup
            let popUpVC = UIStoryboard(name: "AuthenticateUser", bundle: nil).instantiateViewController(withIdentifier: "SignUpPopUpID") as! AuthenticateUserViewController
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.addChildViewController(popUpVC)
            popUpVC.view.frame = self.view.frame
            popUpVC.modalPresentationStyle = .popover
            self.view.addSubview(popUpVC.view)
            popUpVC.didMove(toParentViewController: self)
        } else {
            print(Auth.auth().currentUser?.email)
            performSegue(withIdentifier: "goToCreatePage", sender: self)
        }
    }
    
    func downloadImages(){
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: self.choosedRestaurant.placeId) { (photos, err) in
            if let err = err {
                print("can't get image from this place : \(err)")
            } else {
                if let firstPhoto = photos?.results.first {
                    for pic in (photos?.results)!{
                        GMSPlacesClient.shared().loadPlacePhoto(pic, callback: {
                            (photo, error) -> Void in
                            if let error = error {
                                print("Error Cant show image : \(error)")
                            } else {
                                self.imageArr.append(photo!)
                            }
                        }
                        )}
                } else {
                    self.imageArr.append(#imageLiteral(resourceName: "warning"))
                }
            }
        }
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

extension ChooseActionController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopDetailCell", for: indexPath) as? ShopdetailCollectionViewCell
        cell?.image.image = imageArr[indexPath.row]
        return cell!
    }
}

extension ChooseActionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
