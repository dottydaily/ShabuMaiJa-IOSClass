//
//  AuthenticateUserViewController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 25/1/2562 BE.
//  Copyright © 2562 iOS Dev. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleSignUpButton(_ sender: Any) {
        if (nameTextField.text?.isEmpty)! || (usernameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            
            self.sendAlertWithHandler(Title: "Missing infomation", Description: "Please fill all of infomation") { (alert) in
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        } else {
            let currentUser = Account(name: nameTextField.text!, username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
            
            print("Trying to SignUp")
            Auth.auth().createUser(withEmail: currentUser.email, password: currentUser.password) { (authResult, error) in
                
                if let _error = error {
                    print("CAN'T CREATE USER : \(_error)")
                }
                else if let result = authResult {
                    if result.user == nil {
                        
                    } else {
                        print("CURRENT USER : \(result.user.displayName!)")
                        print("CURRENT EMAIL : \(result.user.email!)")
                        
                        self.view.removeFromSuperview()
                    }
                }
                
                // ...
                guard let user = authResult?.user else { return }
            }
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
