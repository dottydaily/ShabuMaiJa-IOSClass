//
//  SubPageController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 9/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SubPageController: UIViewController {

    var database = Database.database().reference()
    
    @IBOutlet weak var textView : UITextView!
    @IBOutlet weak var textField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func onClickGetMessageButton(_ sender: Any) {
        // testing read data from firebase database
        database.child("testdata").observeSingleEvent(of: .value, with: {(snapshot) in
            // Get user value
            let value = snapshot.value as! NSDictionary // contain received data at "value"
            let greetingMessage = value["GreetMessage"] as! String
            self.textView.text = greetingMessage
        })
    }
    
    @IBAction func onClickSendMessageButton(_ sender: Any) {
        // testing write data to firebase database
        let sendText = self.textField.text
        database.child("testdata/GreetMessage").setValue(sendText)
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
