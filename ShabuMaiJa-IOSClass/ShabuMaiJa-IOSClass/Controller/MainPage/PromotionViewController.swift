//
//  PromotionViewController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Pornpat Santibuppakul on 12/18/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class PromotionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var imageArr: [UIImage] = []

    
    var database: Database?
    var storage: Storage?
    var image: UIImage?
    var totalImage = 0
    var isLoaded = false
    var isFailed = false

   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        database = Database.database()
        storage = Storage.storage()
        
        
        // One cell at a single time
        collectionView.isPagingEnabled = true
       

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(!isLoaded){
            downloadAllImage()
        }
    }
    
    
    func downloadAllImage() {
        imageArr = []
        isFailed = false
        let sv = displaySpinner(onView: self.view, alpha: 0.6)

        self.getData(folderPath: "images", success: {
            self.collectionView.reloadData()
            self.removeSpinner(spinner: sv)
            self.isLoaded = true
        }, failure: { (err) in
            self.removeSpinner(spinner: sv)
            self.sendAlertUtil(Title: "Cant Load Data", Description: "Reload Data")
        }) {
            self.removeSpinner(spinner: sv)
            self.sendAlertWithHandler(Title: "Cant Load Data", Description: "Check Connection", completion: { (alert) in
                alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { (action) in
                    if(self.imageArr.count == self.totalImage){
                        self.collectionView.reloadData()
                        self.isLoaded = true
                    }else{
                        self.downloadAllImage()
                    }
                }))
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func getData(folderPath:String,
                        success:@escaping ()->(),
                        failure:@escaping (_ error:Error)->(),
                        notYet:@escaping ()->()){
        database?.reference().child("NecessaryData").observeSingleEvent(of: .value, with: { (snapshot) in
            let datas = snapshot.value as! NSDictionary
            self.totalImage = datas["PromotionViewImageCount"] as! Int
            self.imageArr = []
            var resStr: String
            
            resStr = ""
            for i in 0 ..< self.totalImage{
                // Create a reference with an initial file path and name
                resStr = String(i)
                let reference = Storage.storage().reference(withPath: "\(folderPath)/\(i).jpg")
                reference.getData(maxSize: (2 * 1024 * 1024)) { (data, error) in
                    if let _error = error{
                        print(_error)
                        self.isFailed = true
                        failure(_error)
                    } else {
                        let myImage:UIImage! = UIImage(data: data! as Data)
                        self.imageArr.append(myImage)
                    }
                    
                    if (self.imageArr.count==self.totalImage) {
                        success()
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                            if(self.imageArr.count < self.totalImage && !self.isFailed){
                                notYet()
                            }else{
                                success()
                            }
                        }
                    }
                    
                }
            }
        })
        
    }
}

extension PromotionViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageCollectionViewCell
        cell?.image.image = imageArr[indexPath.row]
        return cell!
    }
}

extension PromotionViewController: UICollectionViewDelegateFlowLayout {

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


