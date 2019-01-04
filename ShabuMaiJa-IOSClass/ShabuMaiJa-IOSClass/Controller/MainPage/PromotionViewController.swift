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
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    var imageArr = [UIImage(named: "star")]
    let maxProgress:Float = 3.0
    var currentProgress:Float = 0.0
    
    var database: Database?
    var storage: Storage?
    var picArray: [UIImage]?
    var image: UIImage?
    @IBOutlet  var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
   
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        database = Database.database()
        storage = Storage.storage()
        self.downloadImages(folderPath: "images", success: {(image) in print(image)}, failure: {(error) in print(error)})
        
        
        // One cell at a single time
        collectionView.isPagingEnabled = true
        
      
        
        let sv = displaySpinner(onView: self.view)
        //Waiting for image then reload collection view data
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.collectionView.reloadData()
            self.removeSpinner(spinner: sv)
        }
        
    }
    
    func downloadImages(folderPath:String,success:@escaping (_ image:UIImage)->(),failure:@escaping (_ error:Error)->()){
        var count: Int
        var resStr: String
        count = 0
        resStr = ""
        for i in 0 ..< 2{
            // Create a reference with an initial file path and name
            if(i == 0){
                resStr = "Kuma"
                print(resStr)
            }
            else {
                resStr = "Tenjo"
                print(resStr)
            }
            let reference = Storage.storage().reference(withPath: "\(folderPath)/\(resStr).png")
            reference.getData(maxSize: (2 * 1024 * 1024)) { (data, error) in
                if let _error = error{
                    print(_error)
                    failure(_error)
                } else {
                    print("data in")
                    count = count + 1
                    let myImage:UIImage! = UIImage(data: data!)
                    success(myImage)
                    if(count == 1){
                        self.picArray?.append(myImage)
                        self.img1.image = UIImage(data: data!)
                        print(resStr)
                    }
                    else if(count == 2){
                        self.img2.image = UIImage(data: data!)
                        print(resStr)
                    }
                        
                    
                }
            }
        }
        
//        if img.image != nil{
//            img.image = picArray![0]
//            img.setNeedsDisplay()
//        }
//        if img2.image != nil{
//            img2.image = picArray![1]
//            img2.setNeedsDisplay()
//        }

extension PromotionViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageCollectionViewCell
        cell?.image.image = imageArr[indexPath.row + 1]
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


