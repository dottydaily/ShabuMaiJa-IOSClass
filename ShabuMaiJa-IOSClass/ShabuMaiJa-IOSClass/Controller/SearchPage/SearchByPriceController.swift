//
//  SearchByPriceController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by iOS Dev on 29/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class SearchByPriceController: UIViewController {
    
    @IBOutlet weak var minPrice: UITextField!
    @IBOutlet weak var maxPrice: UITextField!
    
    var min: Double = 0
    var max: Double = 99999
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ShowPriceListController
        controller.previousViewController = self
        
        if !(minPrice.text?.isEmpty)! && (minPrice.text?.isInt)! {
            self.min = Double(minPrice.text!)!
        }
        if !(maxPrice.text?.isEmpty)! && (maxPrice.text?.isInt)! {
            if Double(maxPrice.text!)! >= self.min {
                self.max = Double(maxPrice.text!)!
            } else {
                let temp = self.min
                self.min = Double(maxPrice.text!)!
                self.max = temp
//                sendAlertUtil(Title: "Max < Min", Description: "Use default value")
            }
        }
        
        controller.min = min
        controller.max = max
    }

}
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
