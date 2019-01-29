//
//  ProfileViewController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by macOS on 27/1/2562 BE.
//  Copyright © 2562 iOS Dev. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if auth.currentUser != nil {
                let sv = self.displaySpinner(onView: self.view, alpha: 0.6)
                
                self.emailLabel.text = Auth.auth().currentUser?.email!
                self.signInButton.setTitle("Sign Out", for: .normal)
                
                
            } else {
                self.fullNameLabel.text = "Guest"
                self.emailLabel.text = "Please sign in."
                self.signInButton.setTitle("Sign In", for: .normal)
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func handleSignInSignOutButton(_ sender: Any) {
        // if already sign in, this button should do sign out
        if Auth.auth().currentUser != nil {
            self.sendAlertWithHandler(Title: "Confirm Sign Out", Description: "Are you sure?") { (alert) in
                
                // add action of Sign in button
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        self.sendAlertUtil(Title: "Something went wrong", Description: "Please try again later.")
                    }
                }))
                
                // add action of Cancel button
                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            let popUpVC = UIStoryboard(name: "AuthenticateUser", bundle: nil).instantiateViewController(withIdentifier: "SignInPopUpID") as! SignInViewController
            
            popUpVC.previousController = self
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.addChildViewController(popUpVC)
            popUpVC.view.frame = self.view.frame
            popUpVC.modalPresentationStyle = .popover
            self.view.addSubview(popUpVC.view)
            popUpVC.didMove(toParentViewController: self)
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
