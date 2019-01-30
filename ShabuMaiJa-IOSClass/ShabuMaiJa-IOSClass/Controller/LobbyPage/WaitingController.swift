//
//  WaitingController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 23/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WaitingController: UIViewController {
    var hostUID: String! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(hostUID)
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func unwindToPrevious(_ sender: Any) {
       self.navigationController?.popToRootViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller = segue.destination as! EatingHostController
//        controller.hostUserID = self.hostUserID
//        let controllerTable = segue.destination as! ShowProfileController
//        controllerTable.hostUserID = self.hostUserID
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
