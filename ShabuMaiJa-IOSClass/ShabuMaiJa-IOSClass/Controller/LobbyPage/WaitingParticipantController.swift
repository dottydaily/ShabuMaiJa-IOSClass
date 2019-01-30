//
//  WaitingParticipantController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Pornpat Santibuppakul on 1/26/19.
//  Copyright © 2019 iOS Dev. All rights reserved.
//

import UIKit

class WaitingParticipantController: UIViewController {

    @IBOutlet weak var participantTableSubView: UIView!
    
    var choosedLobby: Lobby! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let popUpVC = UIStoryboard(name: "Tab", bundle: nil).instantiateViewController(withIdentifier: "ShowProfileID") as! ShowProfileController
//        popUpVC.hostUserID = self.hostUserID
//
//        self.addChildViewController(popUpVC)
//        popUpVC.view.frame = participantTableSubView.frame
//        popUpVC.modalPresentationStyle = .none
//        self.view.addSubview(popUpVC.view)
//        popUpVC.didMove(toParentViewController: self)
        
    }
    
    @IBAction func unwindToPrevious(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "waitingParticipantSubView" {
            let subVC = segue.destination as! ShowProfileController
            subVC.choosedLobby = choosedLobby
            subVC.loadUser()
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
