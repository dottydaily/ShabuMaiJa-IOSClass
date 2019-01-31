//
//  SignInViewController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by macOS on 27/1/2562 BE.
//  Copyright © 2562 iOS Dev. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var previousController: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func handleSignInButton(_ sender: Any) {
        let sv = self.displaySpinner(onView: self.view, alpha: 0.6)
        
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            self.sendAlertUtil(Title: "Can't sign in", Description: "Please fill all of your information.")
            self.removeSpinner(spinner: sv)
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if let error = error {
                    self.removeSpinner(spinner: sv)
                    self.sendAlertUtil(Title: "Failed to Login", Description: "\(error.localizedDescription)")
                    print(error)
                } else {
                    self.removeSpinner(spinner: sv)
                    print(result)
                    self.handleCancelButton(self)
                }
            }
        }
    }
    @IBAction func handleCancelButton(_ sender: Any) {
        
        print("Removing Sign In view")
        previousController?.navigationController?.navigationBar.isHidden = false
        previousController?.tabBarController?.tabBar.isHidden = false
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    // for mannaul unwind segue
    @IBAction func backToSignInPage(seg: UIStoryboardSegue) {
        if Auth.auth().currentUser != nil {
            handleCancelButton(self)
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
