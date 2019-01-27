//
//  SignInViewController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by macOS on 27/1/2562 BE.
//  Copyright © 2562 iOS Dev. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var previousController: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleSignInButton(_ sender: Any) {
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
