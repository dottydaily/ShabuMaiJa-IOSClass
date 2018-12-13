//
//  ChooseActionController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Pornpat Santibuppakul on 12/13/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import UIKit

class ChooseActionController: UIViewController {
    
    var previousViewController: UIViewController! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToPrevious(_ sender: Any) {
        navigationController?.popToViewController(previousViewController, animated: true)
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
