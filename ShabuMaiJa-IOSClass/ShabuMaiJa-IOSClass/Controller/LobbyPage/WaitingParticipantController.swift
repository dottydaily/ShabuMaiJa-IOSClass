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
        
        Database.database().reference().child("LobbyList/\(choosedLobby.placeId)/\(choosedLobby.hostId)").observe(.value) {
            (snapshot) in
            if (snapshot.key as? String) == nil{
                self.sendAlertUtil(Title: "Host Left", Description: "Please join other lobby")
//                self.unwindToPrevious(self)
            }
        }
    }
    
    @IBAction func unwindToPrevious(_ sender: Any) {
        sendAlertWithHandler(Title: "Cancel your meeting?", Description: "If you accept, you will be remove from this lobby.") { (alert) in
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (alert) in
                
                database.removeParticipant(placeId: self.choosedLobby.placeId, hostId: self.choosedLobby.hostId, userId: (Auth.auth().currentUser?.uid)!, completion: { (isError) in
                    if isError {
                        self.sendAlertUtil(Title: "Something went wrong", Description: "Try again later.")
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
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
