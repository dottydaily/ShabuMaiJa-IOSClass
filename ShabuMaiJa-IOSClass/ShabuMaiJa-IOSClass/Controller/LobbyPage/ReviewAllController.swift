//
//  ReviewAllController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Kanon Limprapaipong on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class ReviewAllController: UIViewController {
    
    var choosedLobby: Lobby! = nil
    var isFromParticipant = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleSubmitButton(_ sender: Any) {
        if isFromParticipant {
            print(choosedLobby.placeId)
            print(choosedLobby.hostId)
            print(Auth.auth().currentUser?.uid)
            database.removeParticipant(placeId: self.choosedLobby.placeId, hostId: self.choosedLobby.hostId, userId: (Auth.auth().currentUser?.uid)!, completion: { (isError, currentPeople) in
                print("Checking if error")
                if isError && (currentPeople != 0) {
                    self.sendAlertUtil(Title: "Something went wrong", Description: "Try again later.")
                } else {
                    isParticipate = false
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        } else {
            isParticipate = false
            database.deleteDataAtPath(path: "LobbyList/\(choosedLobby.placeId)/\((Auth.auth().currentUser?.uid)!)")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
