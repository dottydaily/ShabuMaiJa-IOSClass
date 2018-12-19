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
    
    
    var imageArr = [UIImage(named: "star")]
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
        
        //Waiting for image then reload collection view data
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.collectionView.reloadData()
        }
        
    }
    
    func downloadImages(folderPath:String,success:@escaping (_ image:UIImage)->(),failure:@escaping (_ error:Error)->()){
        
        var resStr: String
        
        resStr = ""
        for i in 0 ..< 3{
            // Create a reference with an initial file path and name
            resStr = String(i)
            let reference = Storage.storage().reference(withPath: "\(folderPath)/\(resStr).png")
            reference.getData(maxSize: (2 * 1024 * 1024)) { (data, error) in
                if let _error = error{
                    print(_error)
                    failure(_error)
                } else {
                    
                    let myImage:UIImage! = UIImage(data: data! as Data)
                    self.imageArr.append(myImage)
                }
            }
        }
        
    }
}

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
