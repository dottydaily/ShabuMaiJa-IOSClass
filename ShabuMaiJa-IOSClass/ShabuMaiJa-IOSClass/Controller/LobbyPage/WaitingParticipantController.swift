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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Database.database().reference().child("LobbyList/\(choosedLobby.placeId)/\(choosedLobby.hostId)/Status").observe(.value) { (snapshot) in
            let status = snapshot.value as! String
            print("test ----------status change ----------")
            print("test \(status)")
            if status == "Eating" {
                self.performSegue(withIdentifier: "toEatingParticipant", sender: self)

            }
        }
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
        
        if segue.identifier == "toEatingParticipant" {
            let controller = segue.destination as! EatingParticipantController
            controller.choosedLobby = choosedLobby
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
