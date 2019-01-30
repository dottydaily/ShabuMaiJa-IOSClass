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
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func handleSignUpButton(_ sender: Any) {
        if (nameTextField.text?.isEmpty)! || (usernameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            
            self.sendAlertWithHandler(Title: "Missing infomation", Description: "Please fill all of infomation") { (alert) in
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        } else {
            let sv = displaySpinner(onView: self.view, alpha: 0.6)
            
            print("Trying to SignUp")
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                
                if let _error = error {
                    print("CAN'T CREATE USER : \(_error)")
                    self.sendAlertUtil(Title: "Error sign up", Description: "\(_error.localizedDescription)")
                    self.removeSpinner(spinner: sv)
                }
                else if let result = authResult {
                    if result.user == nil {
                        // need to do
                    } else {
                        let currentUser = Account(name: self.nameTextField.text!, username: self.usernameTextField.text!, uid:result.user.uid , email: result.user.email!, rating: 5.0)
                        
                        print("CURRENT USER : \(currentUser.username) -> \(currentUser.name)")
                        print("CURRENT UID : \(currentUser.uid)")
                        print("CURRENT EMAIL : \(result.user.email!)")
                        
                        let changeUpdateUserRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        
                        // need to do : update profile
                        // ref : https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/User#createprofilechangerequest
                        
                        changeUpdateUserRequest?.displayName = currentUser.name
                        
                        changeUpdateUserRequest?.commitChanges(completion: { (error) in
                            if let error = error {
                                print(error)
                                self.sendAlertUtil(Title: "Can't update profile", Description: "Try again")
                                self.removeSpinner(spinner: sv)
                            } else {
                                database.createUser(user: currentUser, completion: { (resultUser) in
                                    if let resultUser = resultUser {
                                        self.removeSpinner(spinner: sv)
                                        self.performSegue(withIdentifier: "backToSignInPage", sender: self)
                                    }
                                })
                            }
                        })
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
