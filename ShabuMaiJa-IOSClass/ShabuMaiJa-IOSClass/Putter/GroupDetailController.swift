//
//  GroupDetailController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 16/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class GroupDetailController: UIViewController {
    
    public var ownerName:String!
    public var ownerUsername:String!

    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var groupOwnerName: UILabel!
    @IBOutlet weak var groupOwnerUsername: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.detailTextView.layer.borderWidth = 1
        self.detailTextView.layer.borderColor = UIColor(displayP3Red: 190/255, green: 190/255, blue: 190/255, alpha: 1).cgColor
        
        self.groupOwnerName.text = ownerName
        self.groupOwnerUsername.text = ownerUsername
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! AccountProfileController
        
        controller.name = ownerName
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
