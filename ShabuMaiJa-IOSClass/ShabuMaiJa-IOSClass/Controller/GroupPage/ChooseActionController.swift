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
    var totalImage :Int = 0
    var isLoaded = false
    var isFailed = false
    var handle: AuthStateDidChangeListenerHandle? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(choosedRestaurant!.name)
        database.updatePlace(restaurant: choosedRestaurant) { (restaurantRef) in
        }
        
        print("Start loading image from url")
        
       
        
        // One cell at a single time
        collectionView.isPagingEnabled = true
        
        
        
        //Waiting for image then reload collection view
        nameLabel.text = choosedRestaurant.name
        ratingLabel.text = String(choosedRestaurant.reviewScore)
        addressLabel.text = choosedRestaurant.address
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
        if (!isLoaded){
            downloadImage()
        }
    }
    
    @IBAction func handleCreateButton(_ sender: Any) {
        print("\n\nPREPARING BEFORE GO TO CREATE GROUP")
        if Auth.auth().currentUser == nil {
            handleIfNotSignIn()
        } else {
            print(Auth.auth().currentUser?.email)
            performSegue(withIdentifier: "goToCreatePage", sender: self)
        }
    }
    
    func handleIfNotSignIn() {
        print("nil need to login")
        
        // pop up alert to let user decision if he/she need to sign in or not
        // create subview that let user signin or signup
        self.sendAlertWithHandler(Title: "You are not logged in.", Description: "Please Sign in to use this feature.") { (alert) in
            
            // add action of Sign in button
            alert.addAction(UIAlertAction.init(title: "Sign in", style: .default, handler: { (action) in
                let popUpVC = UIStoryboard(name: "AuthenticateUser", bundle: nil).instantiateViewController(withIdentifier: "SignInPopUpID") as! SignInViewController
               
                popUpVC.previousController = self
                self.navigationController?.navigationBar.isHidden = true
                self.tabBarController?.tabBar.isHidden = true
                self.addChildViewController(popUpVC)
                popUpVC.view.frame = self.view.frame
                popUpVC.modalPresentationStyle = .popover
                self.view.addSubview(popUpVC.view)
                popUpVC.didMove(toParentViewController: self)
            }))
            
            // add action of Cancel button
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func downloadImage(){
        imageArr = []
        totalImage = 0
        isFailed = false
        let sv = self.displaySpinner(onView: self.view, alpha: 1)
        
        getData(success: {
            self.removeSpinner(spinner: sv)
            self.collectionView.reloadData()
            self.isLoaded = true
        }) {
            self.removeSpinner(spinner: sv)
            self.sendAlertWithHandler(Title: "Cant Load Data", Description: "Check Connection", completion: { (alert) in
                alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { (action) in
                    if(self.imageArr.count == self.totalImage){
                        self.isLoaded = true
                        self.collectionView.reloadData()
                    }else{
                        self.downloadImage()
                    }
                }))
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }

    }
    func getData(success:@escaping () ->() ,
                 failure:@escaping () ->()){
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: self.choosedRestaurant.placeId) { (photos, err) in
            
            if let err = err {
                print("can't get image from this place : \(err)")
                failure()
            } else {
                self.imageArr = []
                self.totalImage = (photos?.results.count)!
                print("----------------")
                print(self.totalImage)
                if let firstPhoto = photos?.results.first {
                    for pic in (photos?.results)!{
                        GMSPlacesClient.shared().loadPlacePhoto(pic, callback: {
                            (photo, error) -> Void in
                            if let error = error {
                                self.isFailed = true
                                print("Error Cant show image : \(error)")
                            } else {
                                self.imageArr.append(photo!)
                                print("-----------------\n Loaded Image :\(self.imageArr.count)")
                            }
                            
                            if let lastPhoto = photos?.results.last {
                                print("\n\n Start Checking \n\n")
                                // will do if at last round
                                if self.imageArr.count == self.totalImage{
                                    print("\n\n\n\nSuccess Data : imageArrayList :\(self.imageArr.count), totalImage :\(self.totalImage)\n\n\n\n")
                                    success()
                                }
                                else{ // otherwise
                                    print("\n\n\n OH MY GOD.IT GONNA BE FAILED!?\n\n\n")
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                                        if(self.imageArr.count < self.totalImage && !self.isFailed){
                                            print("\n\n\nFAILED LOADING DATA : \(self.choosedRestaurant.name)\n\n\n")
                                            failure()
                                        }
                                        else {
                                            print("\n\n\n\n\n Final success \n\n\n")
                                            success()
                                        }
                                    }
                                }
                            }
                        })
                    }
                } else {
                    self.imageArr.append(#imageLiteral(resourceName: "warning"))
                    self.totalImage = self.imageArr.count
                    success()
                }
            }
        }
    }
    
    @IBAction func unwindToPrevious(_ sender: Any) {
        navigationController?.popToViewController(previousViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreatePage" {
            var controller = segue.destination as! CreateGroupController
            controller.choosedRestaurant = choosedRestaurant
        } else { // is FindGroupController
            // do something
            var controller = segue.destination as! FindGroupController
            controller.choosedRestaurant = choosedRestaurant
            
        }
        
            
            // use for pop up back to previous view controller
            // because we can go to ChooseActionView by multiple ways
        
        
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
