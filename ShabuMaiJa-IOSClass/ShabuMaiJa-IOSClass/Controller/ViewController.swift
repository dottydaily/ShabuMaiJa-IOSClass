//
//  ViewController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by RomeoAlpha on 1/4/19.
//  Copyright © 2019 iOS Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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

}

extension UIViewController {
    
    // use this anywhere you want to display spinner
    func displaySpinner(onView : UIView, alpha : CGFloat) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: alpha)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    // use this anywhere you want to remove spinner
    func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    // use this anywhere you want to hide keyboard (self.hideKeyboardWhenTappedAround)
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    func sendAlertUtil(Title title: String,Description desc: String){
        let alert = UIAlertController(title: title, message: desc, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func sendAlertWithHandler(Title title: String,Description desc: String,
                              completion:@escaping (UIAlertController)->()){
        let alert = UIAlertController(title: title, message: desc, preferredStyle: .alert)
        
        completion(alert)
    }
}
