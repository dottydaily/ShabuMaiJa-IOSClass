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
    var database: Database?
    var storage: Storage?
    var picArray: [UIImage]?
    var image: UIImage?

    @IBOutlet  var img2: UIImageView!
    @IBOutlet  var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        database = Database.database()
        storage = Storage.storage()
        
        self.downloadImages(folderPath: "images", success: {(image) in print(image)}, failure: {(error) in print(error)})
    
//        img = UIImageView(image: picArray?[0])
//        img2 = UIImageView(image: picArray?[1]
    
    }
    
    func downloadImages(folderPath:String,success:@escaping (_ image:UIImage)->(),failure:@escaping (_ error:Error)->()){
        for _ in 0 ..< 4{
            // Create a reference with an initial file path and name
            let reference = Storage.storage().reference(withPath: "\(folderPath)/Kuma.png")
            
            reference.getData(maxSize: (2 * 1024 * 1024)) { (data, error) in
                if let _error = error{
                    print(_error)
                    failure(_error)
                } else {
                    if let _data  = data {
                        let myImage:UIImage! = UIImage(data: _data)
                        success(myImage)
                        self.picArray?.append(myImage)
                        //self.img.image = UIImage(data: _data)
                        
                    }
                }
            }
        }
        
        if img.image != nil{
            img.image = picArray![0]
            img.setNeedsDisplay()        }
        if img2.image != nil{
            img2.image = picArray![1]
            img2.setNeedsDisplay()
        }

    }
}

