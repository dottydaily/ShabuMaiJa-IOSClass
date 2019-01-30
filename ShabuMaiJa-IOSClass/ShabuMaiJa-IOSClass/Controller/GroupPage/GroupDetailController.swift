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
    var isPressJoin = false
    var isPressViewDetail = false

    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var groupOwnerName: UILabel!
    @IBOutlet weak var groupOwnerUsername: UILabel!
    @IBOutlet weak var amountPeople: UILabel!
    
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
        }
    }
    
    @IBAction func handleJoinButton(_ sender: Any) {
        isPressJoin = true
        performSegue(withIdentifier: "goToWaitingPage", sender: self)
    }
    
    @IBAction func handleViewDetailButton(_ sender: Any) {
        isPressViewDetail = true
        performSegue(withIdentifier: "goToViewProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isPressJoin {
            let controller = segue.destination as! WaitingParticipantController
            
        } else if isPressViewDetail {
            let controller = segue.destination as! AccountProfileController
            
            controller.name = ownerName
        }
        
//        let controller = segue.destination
//        if controller is AccountProfileController {
//            // do something
//            controller.name = ownerName
//        } else { // is FindGroupController
//            // do something
//        }
        
        
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
