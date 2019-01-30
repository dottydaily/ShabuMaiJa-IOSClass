//
//  EatingParticipantController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Pornpat Santibuppakul on 1/26/19.
//  Copyright © 2019 iOS Dev. All rights reserved.
//

import UIKit

class EatingParticipantController: UIViewController {
    
    var choosedLobby: Lobby! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eatingParticipantSubView" {
            let subVC = segue.destination as! ShowProfileController
            subVC.choosedLobby = choosedLobby
            subVC.loadUser()
        }
        
        if segue.identifier == "toReviewUserFromParticipant" {
            let controller = segue.destination as! ReviewAllController
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Database.database().reference().child("LobbyList/\(choosedLobby.placeId)/\(choosedLobby.hostId)/Status").observe(.value) { (snapshot) in
            let status = snapshot.value as! String
            print("test \(status)")
            if status == "Finish" {
                print("testteststsetsteststst")
                self.performSegue(withIdentifier: "toReviewUserFromParticipant", sender: self)
            }
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
