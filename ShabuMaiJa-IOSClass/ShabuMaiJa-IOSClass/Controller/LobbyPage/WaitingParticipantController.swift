//
//  WaitingParticipantController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Pornpat Santibuppakul on 1/26/19.
//  Copyright © 2019 iOS Dev. All rights reserved.
//

import UIKit

class WaitingParticipantController: UIViewController {
    var hostUserID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        database.checkStatusFromLobby(HostUserID: <#T##String#>, placeID: <#T##String#>, status: <#T##String#>) { (status) in
//            if status == "Eat" {
//                self.performSegue(withIdentifier: "toEatingParticipant", sender: self)
//            }
//        }
        
    }
    
    @IBAction func unwindToPrevious(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // dejavu
        let controller = segue.destination as! EatingParticipantController
        controller.hostUserID = self.hostUserID
        let controllerTable = segue.destination as! ShowProfileController
        controllerTable.hostUserID = self.hostUserID
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
