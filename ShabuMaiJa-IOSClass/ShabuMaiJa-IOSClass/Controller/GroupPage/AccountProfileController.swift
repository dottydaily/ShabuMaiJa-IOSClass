//
//  AccountProfileController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 16/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class AccountProfileController: UIViewController {

    public var name: String!
    var previousViewController: UIViewController! = nil
    @IBOutlet weak var accountNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.accountNameLabel.text = name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationController?.popToViewController(previousViewController, animated: true)
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
