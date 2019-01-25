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
    
    var peopleNumber = 1
    let handle: AuthStateDidChangeListenerHandle? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor(displayP3Red: 190/255, green: 190/255, blue: 190/255, alpha: 1).cgColor
        
        self.peopleStepper.minimumValue = Double(peopleNumber)
        self.peopleStepper.stepValue = 1
        
        self.peopleTextField.text = String(Int(peopleStepper.value))
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        self.peopleTextField.text = String(Int(peopleStepper.value))
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("back to chooseAction")
//        Auth.auth().removeStateDidChangeListener(handle!)
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
