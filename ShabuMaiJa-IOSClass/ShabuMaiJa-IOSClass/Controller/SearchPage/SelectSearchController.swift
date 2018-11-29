//
//  SelectSearchController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by iOS Dev on 29/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class SelectSearchController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectPrice(_ sender: Any) {
        performSegue(withIdentifier: "searchSelectPrice", sender: self)
    }
    
    @IBAction func backToSelectSearch(seg:UIStoryboardSegue) {
        
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
