//
//  CreateGroupController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 14/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateGroupController: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var peopleTextField: UITextField!
    @IBOutlet weak var peopleStepper: UIStepper!
    var choosedLobby: Lobby! = nil
    
    var peopleNumber: Int = 2
    let handle: AuthStateDidChangeListenerHandle? = nil
    var choosedRestaurant: Restaurant! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor(displayP3Red: 190/255, green: 190/255, blue: 190/255, alpha: 1).cgColor
        
        self.peopleStepper.minimumValue = Double(peopleNumber)
        self.peopleStepper.stepValue = 1
        
        self.peopleTextField.text = String(Int(peopleStepper.value))
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        peopleNumber = Int(peopleStepper.value)
        self.peopleTextField.text = String(peopleNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("back to chooseAction")
//        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func handleSubmitButton(_ sender: Any) {
        if isParticipate {
            sendAlertUtil(Title: "Can't create", Description: "Has been participating with another room")
            return
        }
        
        let sv = displaySpinner(onView: self.view, alpha: 0.6)
        database.getUser(uid: (Auth.auth().currentUser?.uid)!) { (user) in
            if let user = user {
                print("Success get user data")
                database.createLobby(restaurant: self.choosedRestaurant, host: user, maxPeople: self.peopleNumber, description: self.descriptionTextView.text, completion: {
                    print("Success create lobby")
                    database.getLobby(placeId: self.choosedRestaurant.placeId, hostId: (Auth.auth().currentUser?.uid)!){ (lobby) in
                        self.choosedLobby = lobby
                        print(self.choosedLobby.hostId)
                        self.removeSpinner(spinner: sv)
                        isParticipate = true
                        self.performSegue(withIdentifier: "hostGoToWatingPage", sender: self)
                    }
                })
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hostGoToWatingPage" {
            let controller = segue.destination as! WaitingController
            controller.choosedLobby = self.choosedLobby
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
