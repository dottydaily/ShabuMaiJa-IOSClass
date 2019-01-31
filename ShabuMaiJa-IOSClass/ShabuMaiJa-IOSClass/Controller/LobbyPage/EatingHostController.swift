//
//  EatingHostController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Pornpat Santibuppakul on 1/26/19.
//  Copyright © 2019 iOS Dev. All rights reserved.
//

import UIKit

class EatingHostController: UIViewController {
    
    @IBOutlet weak var peopleLabel: UILabel!
    
    var choosedLobby: Lobby! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Database.database().reference().child("LobbyList/\(choosedLobby.placeId)/\(choosedLobby.hostId)").observe(.value) { (snapshot) in
            if snapshot.exists() {
                let current = snapshot.childSnapshot(forPath: "CurrentPeople").value as! Int
                let total = snapshot.childSnapshot(forPath: "TotalPeople").value as! Int
                
                self.peopleLabel.text = "\(current)/\(total)"
            }
        }
    }
    
    @IBAction func handleFinishButton(_ sender: Any) {
        database.updateStatus(status: "Finish", lobby: choosedLobby)
        performSegue(withIdentifier: "toReviewUser", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eatingSubViewHost" {
            let subVC = segue.destination as! ShowProfileController
            subVC.choosedLobby = choosedLobby
            subVC.loadUser()
        }else if segue.identifier == "toReviewUser" {
            let controller = segue.destination as! ReviewAllController
            controller.choosedLobby = self.choosedLobby
            controller.isFromParticipant = false
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
