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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var controller: ReviewController!
        if (segue.destination is ReviewController) {
            controller = segue.destination as! ReviewController
            
            // use for pop up back to previous view controller
            // because we can go to ChooseActionView by multiple ways
            controller.previousViewController = self
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleSubmitButton(_ sender: Any) {
        isParticipate = false
        database.removeParticipant(placeId: self.choosedLobby.placeId, hostId: self.choosedLobby.hostId, userId: (Auth.auth().currentUser?.uid)!, completion: { (isError) in
            if isError {
                self.sendAlertUtil(Title: "Something went wrong", Description: "Try again later.")
            } else {
                isParticipate = false
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
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
