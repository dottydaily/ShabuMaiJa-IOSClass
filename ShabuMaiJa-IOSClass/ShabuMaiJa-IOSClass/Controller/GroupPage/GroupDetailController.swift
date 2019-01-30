//
//  GroupDetailController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 16/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class GroupDetailController: UIViewController {
    public var placeId:String!
    public var ownerId:String!
    public var ownerName:String!
    public var ownerUsername:String!

    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var groupOwnerName: UILabel!
    @IBOutlet weak var groupOwnerUsername: UILabel!
    @IBOutlet weak var amountPeople: UILabel!
    
    var choosedLobby: Lobby? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.detailTextView.layer.borderWidth = 1
        self.detailTextView.layer.borderColor = UIColor(displayP3Red: 190/255, green: 190/255, blue: 190/255, alpha: 1).cgColor
        self.detailTextView.isEditable = false
        
        self.groupOwnerName.text = ownerName
        self.groupOwnerUsername.text = ownerUsername
        database.getLobby(placeId: placeId, hostId: ownerId) { (lobby) in
            print(lobby.lobbyDescription)
            self.amountPeople.text = "\(lobby.currentPeople)/\(lobby.totalPeople)"
            self.detailTextView.text = lobby.lobbyDescription
            
            self.choosedLobby = lobby
        }
    }
    
    @IBAction func handleJoinButton(_ sender: Any) {
        database.addParticipantLobby(placeId: placeId, hostId: ownerId, userId: (Auth.auth().currentUser?.uid)!) { (isError) in
            if isError {
                self.sendAlertUtil(Title: "Can't join this lobby.", Description: "Participant reach lobby's limit.")
                database.getLobby(placeId: self.placeId, hostId: self.ownerId) { (lobby) in
                    print(lobby.lobbyDescription)
                    self.amountPeople.text = "\(lobby.currentPeople)/\(lobby.totalPeople)"
                    self.detailTextView.text = lobby.lobbyDescription
                }
            } else {
                self.performSegue(withIdentifier: "goToWaitingPage", sender: self)
            }
        }
        
    }
    
    @IBAction func handleViewDetailButton(_ sender: Any) {
        performSegue(withIdentifier: "goToViewProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWaitingPage" {
            let controller = segue.destination as! WaitingParticipantController
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
