//
//  WaitingController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 23/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WaitingController: UIViewController {
    var choosedLobby: Lobby! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func unwindToPrevious(_ sender: Any) {

       self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "waitingSubViewHost" {
            let subVC = segue.destination as! ShowProfileController
            subVC.choosedLobby = choosedLobby
            subVC.loadUser()
        }else{
           let controller = segue.destination as! EatingHostController
            controller.choosedLobby = self.choosedLobby
        }
    }
    @IBAction func handleEatButton(_ sender: Any) {
        database.updateStatus(status: "Eating", lobby: choosedLobby)
        performSegue(withIdentifier: "goToEatingHost", sender: self)
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
